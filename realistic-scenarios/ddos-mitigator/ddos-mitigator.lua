-- RFC2544 Throughput Test
-- as defined by https://www.ietf.org/rfc/rfc2544.txt
package.path = package.path ..";?.lua;test/?.lua;app/?.lua;../?.lua"
require "Pktgen";
require "os";

local config = require "config";

-- define packet sizes to test
-- local pkt_sizes              = { 64, 128, 256, 512, 1024, 1280, 1518 };
local pkt_sizes         = { 64 };
-- Time in seconds to transmit for
local duration           = 15000;
local durationSimpleTest = 60000;
local confirmDuration    = 60000;
local intraRunTime       = 15000;
local pauseTime          = 1000;
local pauseWarmUp        = 1000;
local warmDuration       = 1000;
local runNum             = 5;
local simpleTest         = false;

-- define the ports in use
local sendport          = "0";

-- ip addresses to use
local dstip             = "192.168.1.1";
local srcip             = "192.168.0.1";
local netmask           = "/24";
local remoteDstMAC0     = "3cfd:feaf:ec30"
local remoteDstMAC1     = "3cfd:feaf:ec31"

--src and dest l4 ports
local dstport           = "0x5678"
local srcport           = "0x9988"
 
local initialRate       = 50.0;
local warmUpRate        = 0.01;
local maxLossRate       = 0.011;
local rateThreshold     = 0.01;

--specific test (rule-complexity) configuration
--the configuration is read from the config file
local startSrcIP    = "0.0.0.0"
local endSrcIP      = "0.0.0.0"
local startDstIP    = "0.0.0.0"
local endDstIP      = "0.0.0.0"
local startSport    = 0
local endSport      = 0
local startDport    = 0
local endDport      = 0

local function setupTraffic()
    printf("Setup Traffic\n");
    pktgen.set_mac(sendport, remoteDstMAC0);

    pktgen.set_ipaddr(sendport, "dst", dstip);
    pktgen.set_ipaddr(sendport, "src", srcip..netmask);
                                                                                                                         
    pktgen.set_range(sendport, "on");

    pktgen.delay(1000);
    pktgen.src_ip(sendport, "start", startSrcIP);
    pktgen.src_ip(sendport, "inc", "0.0.0.1");
    pktgen.src_ip(sendport, "min", startSrcIP);
    pktgen.src_ip(sendport, "max", endSrcIP);

    pktgen.delay(1000);
    pktgen.dst_ip(sendport, "start", startDstIP);
    pktgen.dst_ip(sendport, "inc", "0.0.0.1");
    pktgen.dst_ip(sendport, "min", startDstIP);
    pktgen.dst_ip(sendport, "max", endDstIP);

    pktgen.ip_proto(sendport, "udp");
    
    pktgen.delay(1000);
    pktgen.src_port(sendport, "start", startSport);
    pktgen.src_port(sendport, "inc", 1);
    pktgen.src_port(sendport, "min", startSport);
    pktgen.src_port(sendport, "max", endSport);

    pktgen.delay(1000);
    pktgen.dst_port(sendport, "start", startDport);
    pktgen.dst_port(sendport, "inc", 1);
    pktgen.dst_port(sendport, "min", startDport);
    pktgen.dst_port(sendport, "max", endDport);

    pktgen.pkt_size(sendport,"start", 68);
    pktgen.pkt_size(sendport,"inc", 0);
    pktgen.pkt_size(sendport,"start", 68);
    pktgen.pkt_size(sendport,"start", 68);

    pktgen.dst_mac(sendport, "start", remoteDstMAC0);
    pktgen.dst_mac(sendport, "inc", "0000:0000:0000");
    pktgen.dst_mac(sendport, "min", "0000:0000:0000");
    pktgen.dst_mac(sendport, "max", "0000:0000:0000");

    -- set Pktgen to send continuous stream of traffic
    pktgen.set(sendport, "count", 0);
end

local function runTrial(rate, duration, count)
    local num_tx, mpps;
    local results = {spkts = 0, mpps = 0.0}
    local duration_sec = duration / 1000
    printf("Setting rate to %f \n", rate);
    print("Setting rate to " .. rate);
    pktgen.clr();

    pktgen.set(sendport, "rate", rate);
    pktgen.start(sendport);

    print("Running trial " .. count .. ". % Rate: " .. rate .. ". Duration (mS):" .. duration_sec);

    pktgen.delay(duration);
    pktgen.stop(sendport);
    pktgen.delay(pauseTime);

    statTx = pktgen.portStats(sendport, "port")[tonumber(sendport)];
    num_tx = statTx.opackets;
    results.spkts = num_tx
    results.mpps = num_tx / 10^6 / duration_sec

    print("Tx: " .. num_tx .. ". Mpps: " .. results.mpps .. "\n");

    pktgen.delay(pauseTime);

    return results;
end

local function runSimpleTest(startRate)
    local lossRate, max_rate, min_rate, trial_rate, last_rate, maxLossRate, finished;
    str = ""
    printf("Start rate %f\n", startRate);
    result = runTrial(startRate, durationSimpleTest, 1);
    print("Sent Mpps: " .. result.mpps .. "\n");
    file:write("Pktgen Sent Mpps: " .. result.mpps .. "\n");
end

function tableHasKey(table,key)
    return table[key] ~= nil
end

local function configureGlobalVariable()
    remoteDstMAC0 = config.test.dstMac0;
    remoteDstMAC1 = config.test.dstMac1;
    runNum = config.test.num_runs;

    if config.test.simple_test == 1 then
        simpleTest = true;
    end

    startSrcIP = config.test.startSrcIP
    endSrcIP = config.test.endSrcIP
    startDstIP = config.test.startDstIP
    endDstIP = config.test.endDstIP
    startSport = config.test.startSport
    endSport = config.test.endSport
    startDport = config.test.startDport
    endDport = config.test.endDport

    if tableHasKey(config.test, "startRate") then
        initialRate = config.test.startRate
    end
end

-- The first parameter passed to this script if set to false doesn't perform
-- the binary search for the throughput
function main()
    local file_name = "pcn-iptables-forward.csv";

    file = io.open(file_name, "w+");
    
    if tableHasKey(config, "test") then
        configureGlobalVariable();
    end

    for _,size in pairs(pkt_sizes)
    do
      setupTraffic();
      if simpleTest then
        runSimpleTest(initialRate);
      end
    end

    file:write("\n");
    file:flush();
    file:close();
end

main();
pktgen.quit();
