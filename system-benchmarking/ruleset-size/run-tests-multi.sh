#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
NOW=$(date +"%m-%d-%Y-%T")

# Remote configurations (DUT)
REMOTE_DUT=IPADDRESS
REMOTE_FOLDER="~/bpf-iptables-tests/system-benchmarking/ruleset-size"
DST_MAC_IF0="3cfd:feaf:ec30"
DST_MAC_IF1="3cfd:feaf:ec31"
INGRESS_IFACE_NAME="enp101s0f0"
SET_IRQ_SCRIPT="~/bpf-iptables-tests/common-scripts/set_irq_affinity"

polycubed="sudo polycubed"
polycubectl="$GOPATH/bin/polycubectl"

# Local configurations (Pkt generator)
FORWARD_TEST_LOG=forward_test.$NOW.log
PKTGEN_FOLDER="$HOME/dev/pktgen-dpdk"
POLYCUBE_VERSION="none"
IPTABLES="pcn-iptables"
LOCAL_NAME=cube1
LOCAL_DUT=IPADDRESS
START_RATE=50.0

declare -a ruleset_values=("50" "100" "500" "1000" "5000")

#######################################
# Specific Test (srcip) Configuration #
#######################################
function generate_test_configuration() {
local test_name=$1
if [ $test_name == "50" ]; then
  START_SRC_IP=192.168.0.2
  END_SRC_IP=192.168.0.4
  NUM_IP_SRC=3
  START_DST_IP=192.168.1.2
  END_DST_IP=192.168.1.4
  NUM_IP_DST=3
  START_SPORT=10100
  END_SPORT=10102
  START_DPORT=8080
  END_DPORT=8081
elif [ $test_name == "100" ]; then
  START_SRC_IP=192.168.0.2
  END_SRC_IP=192.168.0.6
  NUM_IP_SRC=5
  START_DST_IP=192.168.1.2
  END_DST_IP=192.168.1.6
  NUM_IP_DST=5
  START_SPORT=10100
  END_SPORT=10101
  START_DPORT=8080
  END_DPORT=8081
elif [ $test_name == "500" ]; then
  START_SRC_IP=192.168.0.2
  END_SRC_IP=192.168.0.6
  NUM_IP_SRC=5
  START_DST_IP=192.168.1.2
  END_DST_IP=192.168.1.6
  NUM_IP_DST=5
  START_SPORT=10100
  END_SPORT=10109
  START_DPORT=8080
  END_DPORT=8081
elif [ $test_name == "1000" ]; then
  START_SRC_IP=192.168.0.2
  END_SRC_IP=192.168.0.11
  NUM_IP_SRC=10
  START_DST_IP=192.168.1.2
  END_DST_IP=192.168.1.6
  NUM_IP_DST=5
  START_SPORT=10100
  END_SPORT=10103
  START_DPORT=8080
  END_DPORT=8084
elif [ $test_name == "5000" ]; then
  START_SRC_IP=192.168.0.2
  END_SRC_IP=192.168.0.11
  NUM_IP_SRC=10
  START_DST_IP=192.168.1.2
  END_DST_IP=192.168.1.6
  NUM_IP_DST=5
  START_SPORT=10100
  END_SPORT=10109
  START_DPORT=8080
  END_DPORT=8089
else
  echo "Test case not supported"
  exit 1
fi
}


function show_help() {
usage="$(basename "$0") [-h] [-r #runs] [-o output_file] [-i|-n]
Run tests of pcn-iptables for the FORWARD chain with a different number of rules

where:
    -h  show this help text
    -r  number of runs for the test
    -o  path to file where the results are placed
    -i  use iptables
    -n  use nftables"

echo "$usage"
}

# Kill polycubed, and wait all services to be unloaded and process to be completely killed
function polycubed_kill_and_wait {
  echo "killing polycubed ..."
  sudo pkill polycubed > /dev/null 2>&1

  done=0
  i=0
  while : ; do
    sleep 1
    alive=$(ps -el | grep polycubed)
    if [ -z "$alive" ]; then
      done=1
    fi

    i=$((i+1))

    if [ "$done" -eq 1 ]; then
        echo "killing polycubed in $i seconds"
        break
    fi
  done
}

function setup_environment {
  size=$1
ssh polycube@$REMOTE_DUT << EOF
  set -x
  sudo sh -c "echo 1 > /proc/sys/net/core/bpf_jit_enable"
  sudo bash -c "exec -a config_dut $REMOTE_FOLDER/config_dut_routing.sh > /home/polycube/log 2>&1 &"
  sudo bash -c "$REMOTE_FOLDER/rulesets/rules_$size.sh $IPTABLES FORWARD"
EOF
}

function start_remote_cpu_monitor {
  size=$1
  add_arg=$2
  ssh polycube@$REMOTE_DUT << EOF
  set -x
  sudo sar -P ALL -o /tmp/output_usage.$NOW.$size.$add_arg 5 >/dev/null 2>&1 &
EOF
}

function stop_remote_cpu_monitor {
  size=$1
  add_arg=$2
  ssh polycube@$REMOTE_DUT << EOF
  set -x
  sudo killall sar
  scp /tmp/output_usage.$NOW.$size.$add_arg $LOCAL_NAME@$LOCAL_DUT:$DIR/output_usage.$NOW.$size.$add_arg
EOF
}

function cleanup_environment {
ssh polycube@$REMOTE_DUT << EOF
  $(typeset -f polycubed_kill_and_wait)
  polycubed_kill_and_wait
  sudo iptables -F FORWARD
  sudo nft flush table ip filter
  sudo nft delete table ip filter
  sudo pkill config_dut
EOF
}

function wait_for_remote_machine {
ssh -q polycube@$REMOTE_DUT exit
result=$?
sleep 5
while [ $result -ne 0 ]; do
  ssh -q polycube@$REMOTE_DUT exit #Loop until the host becomes ready
  result=$?
  sleep 5
done
}

function reboot_remote_dut {
ssh polycube@$REMOTE_DUT << EOF
  set -x
  sudo reboot
EOF
}

function check_conntrack {
local enabled=$(ssh polycube@$REMOTE_DUT "lsmod | grep conntrack")
local result='disabled'
if [ -z "$enabled"]; then
	# Conntrack is disabled
	result='disabled'
else
	result='enabled'
fi
echo "$result"
}

function disable_conntrack {
ssh polycube@$REMOTE_DUT << EOF
  sudo $REMOTE_CONNTRACK_SCRIPT_FOLDER/disable.sh
  sudo rmmod iptable_nat
  sudo rmmod ipt_MASQUERADE
  sudo rmmod nf_nat_ipv4
  sudo rmmod nf_nat
  sudo rmmod xt_conntrack
  sudo rmmod nf_conntrack_netlink
  sudo rmmod nf_conntrack
  sudo rmmod iptable_filter
  sudo rmmod ip_tables
  sudo rmmod nf_defrag_ipv6
  sudo rmmod nf_defrag_ipv4
  sudo rmmod x_tables
  sudo rmmod ip_set_hash_ipport
  sudo rmmod ip_set
EOF
}

function disable_nft {
ssh polycube@$REMOTE_DUT << EOF
  sudo rmmod nft_counter
  sudo rmmod nft_ct
  sudo rmmod nf_tables
EOF
}

function cleanup {
  set +e
  cleanup_environment
}

# The argument of this function is the range of cores to be used
# or 'all' in case all cores are used
function set_irq_affinity {
ssh polycube@$REMOTE_DUT << EOF
  set -x
  sudo $SET_IRQ_SCRIPT $1 $INGRESS_IFACE_NAME
EOF
}

function generate_pktgen_config_file {
#Create configuration file for swagger-codegen
cat > ${PKTGEN_FOLDER}/config.lua << EOF
-- config.lua
-- Automatically generated at ${NOW}

local _M = {}

_M.test = {
    dstMac0 = "${DST_MAC_IF0}",
    dstMac1 = "${DST_MAC_IF1}",
    num_runs = ${NUMBER_RUNS},
    simple_test = $1,
    startSrcIP = "${START_SRC_IP}",
    endSrcIP = "${END_SRC_IP}",
    startDstIP = "${START_DST_IP}",
    endDstIP = "${END_DST_IP}",
    startSport = ${START_SPORT},
    endSport = ${END_SPORT},
    startDport = ${START_DPORT},
    endDport = ${END_DPORT},
    startRate = ${START_RATE},
}

return _M
EOF
}

#set -e

while getopts :r:o:inh option; do
 case "${option}" in
 h|\?)
	show_help
	exit 0
	;;
 r) NUMBER_RUNS=${OPTARG}
	;;
 o) OUT_FILE=${OPTARG}
	;;
 i) IPTABLES="iptables"
  ;;
 n) IPTABLES="nftables"
  ;;
 :)
    echo "Option -$OPTARG requires an argument." >&2
    show_help
    exit 0
    ;;
 esac
done

if [ -f $FORWARD_TEST_LOG ]; then
	rm $FORWARD_TEST_LOG
fi

if [ -z ${NUMBER_RUNS+x} ]; then
	echo "You should specify the number of runs with the -r option" >&2;
	show_help
	exit 0
fi

if [ -z ${OUT_FILE+x} ]; then
	echo "You should specify the output file with the -o option" >&2;
	show_help
	exit 0
fi

set -x

for size in "${ruleset_values[@]}"; do
  set +e

  generate_test_configuration $size

  while true; do
	wait_for_remote_machine
	conntrack=$(check_conntrack)
	if [ $conntrack == "enabled" ] && [ ${IPTABLES} == "pcn-iptables" ]
	then
		disable_conntrack
		reboot_remote_dut
	    wait_for_remote_machine
	else
		break
	fi
  done

  set -e
  cleanup

  if [ ${IPTABLES} == "pcn-iptables"  ]; then
    ssh polycube@$REMOTE_DUT "$polycubed --version" > $DIR/"$OUT_FILE-$size.txt"
  elif [ ${IPTABLES} == "iptables"  ]; then
    ssh polycube@$REMOTE_DUT "sudo iptables --version" > $DIR/"$OUT_FILE-$size.txt"
  else 
    ssh polycube@$REMOTE_DUT "sudo nft --version" > $DIR/"$OUT_FILE-$size.txt"
  fi

  echo "Processing size: $size" >> $DIR/"$OUT_FILE-$size.txt"
  ssh polycube@$REMOTE_DUT "uname -r" >> $DIR/"$OUT_FILE-$size.txt"
  echo "" >> $DIR/"$OUT_FILE-$size.txt"
  #####################################################
  # Execute the first test with interrupts set to all #
  #####################################################
  START_RATE=50.0
  setup_environment $size
  set_irq_affinity "all"

  sleep 5
  generate_pktgen_config_file 0
  start_remote_cpu_monitor $size "multi-core"

  if [ ${IPTABLES} == "pcn-iptables"  ]; then
		disable_nft
		disable_conntrack
  fi

  cd $PKTGEN_FOLDER
  sudo ./app/x86_64-native-linuxapp-gcc/pktgen -c ff -n 4 --proc-type auto --file-prefix pg -- -T -P -m "[1:2/3/4/5].0, [6/7].1" -f $DIR/ruleset-size.lua
  sleep 5
  stop_remote_cpu_monitor $size "multi-core"

  cat "pcn-iptables-forward.csv" >> $DIR/"$OUT_FILE-$size.txt"

  cleanup_environment
  sleep 5
  ###################################################
  # Execute now a simple test without binary search #
  ###################################################
  setup_environment $size
  set_irq_affinity "all"

  sleep 5
  generate_pktgen_config_file 1

  if [ ${IPTABLES} == "pcn-iptables"  ]; then
		disable_nft
		disable_conntrack
  fi

  cd $PKTGEN_FOLDER
  sudo ./app/x86_64-native-linuxapp-gcc/pktgen -c ff -n 4 --proc-type auto --file-prefix pg -- -T -P -m "[1:2/3/4/5].0, [6/7].1" -f $DIR/ruleset-size.lua
  sleep 5

  echo "" >> $DIR/"$OUT_FILE-$size.txt"
  echo "SimpleTest" >> $DIR/"$OUT_FILE-$size.txt"

  cat "pcn-iptables-forward.csv" >> $DIR/"$OUT_FILE-$size.txt"

  cleanup_environment
  sleep 30
  cd $DIR
done

reboot_remote_dut
exit 0
