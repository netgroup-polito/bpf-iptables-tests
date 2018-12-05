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

local binarySearch = {}
binarySearch.__index = binarySearch

function binarySearch:create(lower, upper)
    local self = setmetatable({}, binarySearch)
    self.lowerLimit = lower
    self.upperLimit = upper
    return self
end

setmetatable(binarySearch, { __call = binarySearch.create })

function binarySearch:init(lower, upper)
    self.lowerLimit = lower
    self.upperLimit = upper
end

function binarySearch:next(curr, top, threshold)
    if top then
        if curr == self.upperLimit then
            return curr, true
        else
            self.lowerLimit = curr
        end
    else
        if curr == lowerLimit then            
            return curr, true
        else
            self.upperLimit = curr
        end
    end
    local nextVal = (self.lowerLimit + self.upperLimit)/2
    --local nextVal = math.ceil((self.lowerLimit + self.upperLimit) / 2)
    if (math.abs(nextVal - curr) < threshold) then
        return curr, true
    end
    return nextVal, false
end

local function setupTraffic()
    printf("Setup Traffic\n");
    pktgen.set_mac(sendport, remoteDstMAC0);
    pktgen.set_mac(recvport, remoteDstMAC1);

    pktgen.set_ipaddr(sendport, "dst", dstip);
    pktgen.set_ipaddr(sendport, "src", srcip..netmask);
    pktgen.set_ipaddr(recvport, "dst", srcip);
    pktgen.set_ipaddr(recvport, "src", dstip..netmask);
                                                                                                                         
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

local function runTrial(pkt_size, rate, duration, count)
    local num_tx, num_rx, num_dropped, loss_rate, mpps;
    local results = {spkts = 0, rpkts = 0, mpps = 0.0, pkt_size = pkt_size}
    local duration_sec = duration / 1000
    printf("Setting rate to %f \n", rate);
    print("Setting rate to " .. rate);
    pktgen.clr();
    --pktgen.set(recvport, "rate", 100);
    pktgen.set(sendport, "rate", rate);
    pktgen.set(sendport, "size", pkt_size);
    pktgen.start(sendport);
    print("Running trial " .. count .. ". % Rate: " .. rate .. ". Packet Size: " .. pkt_size .. ". Duration (mS):" .. duration_sec);
    -- file:write("Running trial " .. count .. ". % Rate: " .. rate .. ". Packet Size: " .. pkt_size .. ". Duration (mS):" .. duration_sec);
    -- file:write("Running trial " .. count .. ". % Rate: " .. rate .. ". Packet Size: " .. pkt_size .. ". Duration (mS):" .. duration .. "\n");
    pktgen.delay(duration);
    pktgen.stop(sendport);
    pktgen.delay(pauseTime);
    statTx = pktgen.portStats(sendport, "port")[tonumber(sendport)];
    statRx = pktgen.portStats(recvport, "port")[tonumber(recvport)];
    num_tx = statTx.opackets;
    num_rx = statRx.ipackets;
    num_dropped = num_tx - num_rx;
    lossRate = num_dropped / num_tx
    validRun = lossRate <= maxLossRate
    results.spkts = num_tx
    results.rpkts = num_rx
    results.mpps = num_rx / 10^6 / duration_sec -- Before was num_tx
    results.pkt_size = pkt_size
    results.lossRate = lossRate
    --if validRun then
    --      results = {spkts = num_tx, rpkts = num_rx, mpps = mpps, pkt_size = pkt_size}
    --end
    print("Tx: " .. num_tx .. ". Rx: " .. num_rx .. ". Dropped: " .. num_dropped .. ". LossRate: " .. lossRate .. ". Mpps: " .. results.mpps .. "\n");
    -- file:write("Tx: " .. num_tx .. ". Rx: " .. num_rx .. ". Dropped: " .. num_dropped .. ". LossRate: " .. lossRate .. "\n");
    -- file:write("Tx: " .. num_tx .. ". Rx: " .. num_rx .. ". Dropped: " .. num_dropped .. ". LossRate: " .. lossRate .. ". Mpps: " .. results.mpps .. "\n");
    pktgen.delay(pauseTime);
    return results, lossRate, validRun;
end

local function warmFwdTable(pkt_size)
    pktgen.clr();
    pktgen.set(recvport, "rate", warmUpRate);
    -- pktgen.set(sendport, "size", pkt_size);
    print("Warm....");
    pktgen.start(recvport);
    pktgen.delay(warmDuration);
    pktgen.stop(recvport);
    pktgen.delay(pauseWarmUp);
end

local function getCSVHeader()
    local str = "iteration, frame size(byte),duration(s),max loss rate(%),rate threshold(packets)";
    str = str .. "," .. "rate(mpps),spkts,rpkts,throughput(Mbit/s),throughput wire rate(Mbit/s)\n";
    return str;
end

function deep_copy(obj, seen)
  -- Handle non-tables and previously-seen tables.
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end

  -- New table; mark it as seen an copy recursively.
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[deep_copy(k, s)] = deep_copy(v, s) end
  return res
end

local function runThroughputTest(pkt_size)
    local lossRate, max_rate, min_rate, trial_rate, last_rate, maxLossRate, finished;
    local binSearch = binarySearch()
    local final_result = {}
    final_result.mpps = 0.0;
    final_result.lossRate = 1.0;
    maxLossRate = 0.01;
    max_rate = 100.0;
    min_rate = 1;
    str = ""
    for count=1, runNum, 1 do
        binSearch:init(0.0, max_rate);
        trial_rate = initialRate;
        while true do
            printf("Trial rate %f\n", trial_rate);
            result, lossRate, validRun = runTrial(pkt_size, trial_rate, duration, count);
	    if validRun then
		final_result = deep_copy(result)
	    end
            last_rate = trial_rate;
            trial_rate, finished = binSearch:next(trial_rate, validRun, rateThreshold);
            if finished then
                local duration_sec = duration / 1000
                str = count .. "," .. pkt_size .. "," .. duration_sec .. "," .. maxLossRate * 100 .. "," .. rateThreshold .. "," .. result.mpps .. "," .. result.spkts .. "," .. result.rpkts .. "," .. (result.mpps * result.pkt_size * 8) .. "," .. (result.mpps * (result.pkt_size + 20) * 8)
                -- file:write(str .. "\n");
                print("Found Mpps: " .. final_result.mpps .. "\n");
                file:write("Size: " .. pkt_size .. " Found Mpps: " .. final_result.mpps .. " LossRate: " .. final_result.lossRate .. "\n");    
                --file:write("Found Mpps: " .. result.mpps .. "\n");
                break   
            end
            printf("changing rate from %f to %f\n", last_rate, trial_rate);
            pktgen.delay(pauseTime);
        end
        pktgen.delay(intraRunTime);

    end
end

local function runSimpleTest(pkt_size, startRate)
    local lossRate, max_rate, min_rate, trial_rate, last_rate, maxLossRate, finished;
    str = ""
    printf("Start rate %f\n", startRate);
    result, lossRate, validRun = runTrial(pkt_size, startRate, durationSimpleTest, 1);
    print("Found Mpps: " .. result.mpps .. "\n");
    file:write("Size: " .. pkt_size .. " Found Mpps: " .. result.mpps .. " LossRate: " .. lossRate .. "\n");
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
        runSimpleTest(size, 50.0);
      else
        runThroughputTest(size);
      end
    end

    file:write("\n");
    file:flush();
    file:close();
end

main();
pktgen.quit();
