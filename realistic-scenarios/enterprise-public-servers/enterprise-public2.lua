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
local recvport          = "1";

-- ip addresses to use
local dstip             = "192.168.1.1";
local srcip             = "192.168.0.1";
local netmask           = "/24";
local remoteDstMAC0     = "3cfd:feaf:ec30"
local remoteDstMAC1     = "3cfd:feaf:ec31"

--src and dest l4 ports
local dstport           = "0x5678"
local srcport           = "0x9988"
 
local initialRate       = 50;
local warmUpRate        = 0.01;
local maxLossRate       = 0.01;
rateThreshold           = 0.1;

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

local function setupTrafficPort0()                                                                                                                        
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

    pktgen.ip_proto("all", "udp");
    
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

local function setupTrafficPort1()                                                                                                                      
    pktgen.set_range(recvport, "on");

    pktgen.delay(1000);
    pktgen.src_ip(recvport, "start", startDstIP);
    pktgen.src_ip(recvport, "inc", "0.0.0.1");
    pktgen.src_ip(recvport, "min", startDstIP);
    pktgen.src_ip(recvport, "max", endDstIP);

    pktgen.delay(1000);
    pktgen.dst_ip(recvport, "start", startSrcIP);
    pktgen.dst_ip(recvport, "inc", "0.0.0.1");
    pktgen.dst_ip(recvport, "min", startSrcIP);
    pktgen.dst_ip(recvport, "max", endSrcIP);

    pktgen.ip_proto("all", "udp");
    
    pktgen.delay(1000);
    pktgen.src_port(recvport, "start", startDport);
    pktgen.src_port(recvport, "inc", 1);
    pktgen.src_port(recvport, "min", startDport);
    pktgen.src_port(recvport, "max", endDport);

    pktgen.delay(1000);
    pktgen.dst_port(recvport, "start", startSport);
    pktgen.dst_port(recvport, "inc", 1);
    pktgen.dst_port(recvport, "min", startSport);
    pktgen.dst_port(recvport, "max", endSport);

    pktgen.pkt_size(recvport,"start", 68);
    pktgen.pkt_size(recvport,"inc", 0);
    pktgen.pkt_size(recvport,"start", 68);
    pktgen.pkt_size(recvport,"start", 68);

    pktgen.dst_mac(recvport, "start", remoteDstMAC1);
    pktgen.dst_mac(recvport, "inc", "0000:0000:0000");
    pktgen.dst_mac(recvport, "min", "0000:0000:0000");
    pktgen.dst_mac(recvport, "max", "0000:0000:0000");

    -- set Pktgen to send continuous stream of traffic
    pktgen.set(recvport, "count", 0);
end

local function runTrial(pkt_size, rate, duration, count)
    local num_port0_tx, num_port0_rx, num_port1_tx, num_port1_rx, num_port0_dropped, num_port1_dropped, lossRate_port0, lossRate_port1, mpps;
    local results = {port0_spkts = 0, port0_rpkts = 0, port1_spkts = 0, port1_rpkts = 0, port0_mpps = 0.0, port1_mpps = 0.0, pkt_size = pkt_size}
    local duration_sec = duration / 1000
    printf("Setting rate to %f \n", rate);
    print("Setting rate to " .. rate);
    pktgen.clr();
    --pktgen.set(recvport, "rate", 100);
    pktgen.set("all", "rate", rate);
    pktgen.set("all", "size", pkt_size);
    pktgen.start("all");

    print("Running trial " .. count .. ". % Rate: " .. rate .. ". Packet Size: " .. pkt_size .. ". Duration (mS):" .. duration_sec);
    
    pktgen.delay(duration);
    pktgen.stop("all");
    pktgen.delay(pauseTime);

    statPort0 = pktgen.portStats(sendport, "port")[tonumber(sendport)];
    statPort1 = pktgen.portStats(recvport, "port")[tonumber(recvport)];
    num_port0_tx = statPort0.opackets;
    num_port0_rx = statPort0.ipackets;
    num_port1_tx = statPort1.opackets;
    num_port1_rx = statPort1.ipackets;
    
    num_port0_dropped = num_port0_tx - num_port1_rx;
    num_port1_dropped = num_port1_tx - num_port0_rx;
    lossRate_port0 = num_port0_dropped / num_port0_tx
    lossRate_port1 = num_port1_dropped / num_port1_tx
    validRun = lossRate_port0 <= maxLossRate
    results.port0_spkts = num_port0_tx
    results.port0_rpkts = num_port0_rx
    results.port1_spkts = num_port1_tx
    results.port1_rpkts = num_port1_rx

    results.port0_mpps = num_port1_rx / 10^6 / duration_sec -- Before was num_tx
    results.port1_mpps = num_port0_rx / 10^6 / duration_sec -- Before was num_tx
    results.pkt_size = pkt_size
    
    print("Port0_tx: " .. num_port0_tx .. ". Port0_tx: " .. num_port0_rx .. ". Port1_tx: " .. num_port1_tx .. ". Port1_tx: " .. num_port1_rx);
    print("Port0_dropped: " .. num_port0_dropped .. " Port1_dropped: " .. num_port1_dropped);
    print("Port0_lossRate: " .. lossRate_port0 .. " Port1_lossRate: " .. lossRate_port1);
    print("Port0_mpps: " .. results.port0_mpps .. " Port1_mpps: " .. results.port1_mpps);
        
    pktgen.delay(pauseTime);
    return results, lossRate_port0, lossRate_port1, validRun;
end

local function getCSVHeader()
    local str = "iteration, frame size(byte),duration(s),max loss rate(%),rate threshold(packets)";
    str = str .. "," .. "rate(mpps),spkts,rpkts,throughput(Mbit/s),throughput wire rate(Mbit/s)\n";
    return str;
end

local function runSimpleTest(pkt_size, startRate)
    local lossRate_port0, lossRate_port1, max_rate, min_rate, trial_rate, last_rate, maxLossRate, finished;
    str = ""
    printf("Start rate %f\n", startRate);
    result, lossRate_port0, lossRate_port1, validRun = runTrial(pkt_size, startRate, durationSimpleTest, 1);
    print("Found Port0_mpps: " .. result.port0_mpps .. "\n");
    print("Found Port1_mpps: " .. result.port1_mpps .. "\n");
    file:write("Size: " .. pkt_size .. " Found Port0_mpps: " .. result.port0_mpps .. " Port0_LossRate: " .. lossRate_port0 .. "\n");
    file:write("Size: " .. pkt_size .. " Found Port1_mpps: " .. result.port1_mpps .. " Port1_LossRate: " .. lossRate_port1 .. "\n");
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

    if tableHasKey(config.test, "testDuration") then
        durationSimpleTest = config.test.testDuration
    end
end

function main()
    local file_name = "pcn-iptables-forward.csv";

    file = io.open(file_name, "w+");
    
    if tableHasKey(config, "test") then
        configureGlobalVariable();
    end

    for _,size in pairs(pkt_sizes)
    do
      setupTrafficPort0();
      setupTrafficPort1();
      if simpleTest then
        runSimpleTest(size, initialRate);
      else
        pktgen.quit();
      end
    end

    file:write("\n");
    file:flush();
    file:close();
end

main();
pktgen.quit();
