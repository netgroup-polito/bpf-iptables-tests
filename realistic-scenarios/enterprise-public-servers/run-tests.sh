#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
NOW=$(date +"%m-%d-%Y-%T")

###############################
# Remote configurations (DUT) #
###############################
REMOTE_DUT=130.192.225.106
REMOTE_FOLDER="~/bpf-iptables-tests/realistic-scenarios/enterprise-public2"
SET_IRQ_SCRIPT="~/bpf-iptables-tests/common-scripts/set_irq_affinity"
DST_MAC_IF0="3cfd:feaf:ec30"
DST_MAC_IF1="3cfd:feaf:ec31"
INGRESS_IFACE_NAME="enp101s0f0"
EGRESS_IFACE_NAME="enp101s0f1"

polycubed="sudo polycubed"
polycubectl="$GOPATH/bin/polycubectl"

########################################
# Local configurations (Pkt generator) #
########################################
FORWARD_TEST_LOG=forward_test.$NOW.log
PKTGEN_FOLDER="$HOME/dev/pktgen-dpdk"
POLYCUBECTL_CONFIG_FILE="$HOME/.config/polycube/polycubectl_config.yaml"
POLYCUBE_VERSION="none"
IPTABLES="pcn-iptables"
LOCAL_NAME=cube1
LOCAL_DUT=130.192.225.61
START_RATE=25
TEST_DURATION=30

declare -a ruleset_values=("50" "100" "500" "1000" "5000")

###############################
# Specific Test Configuration #
###############################
function generate_test_configuration() {
local test_name=$1
if [ $test_name == "50" ]; then
	# Adding 10% (2) of traffic that is not in the ruleset (DROPPED)
	START_SRC_IP=192.168.0.2
	END_SRC_IP=192.168.0.11
	NUM_IP_SRC=10
	START_DST_IP=192.168.10.2
	END_DST_IP=192.168.10.7	# was 192.168.0.6
	NUM_IP_DST=6 # was 5
	START_SPORT=10100
	END_SPORT=10110
	START_DPORT=8080
	END_DPORT=8088
elif [ $test_name == "100" ]; then
	START_SRC_IP=192.168.0.2
	END_SRC_IP=192.168.0.11
	NUM_IP_SRC=10
	START_DST_IP=192.168.10.2
	END_DST_IP=192.168.10.12 # was 192.168.0.11
	NUM_IP_DST=11 # was 10
	START_SPORT=10100
	END_SPORT=10110
	START_DPORT=8080
	END_DPORT=8088
elif [ $test_name == "500" ]; then
	START_SRC_IP=192.168.0.2
	END_SRC_IP=192.168.0.11
	NUM_IP_SRC=10
	START_DST_IP=192.168.10.2
	END_DST_IP=192.168.10.51
	NUM_IP_DST=50
	START_SPORT=10100
	END_SPORT=10110
	START_DPORT=8080
	END_DPORT=8089 # was 8088 + 1
elif [ $test_name == "1000" ]; then
	START_SRC_IP=192.168.0.2
	END_SRC_IP=192.168.0.11
	NUM_IP_SRC=10
	START_DST_IP=192.168.10.2
	END_DST_IP=192.168.10.27 # was 192.168.0.26
	NUM_IP_DST=26 # was 25 + 1
	START_SPORT=10100
	END_SPORT=10110
	START_DPORT=8080
	END_DPORT=8120 # was 8118 + 2
elif [ $test_name == "5000" ]; then
	START_SRC_IP=192.168.0.2
	END_SRC_IP=192.168.0.11
	NUM_IP_SRC=10
	START_DST_IP=192.168.10.2
	END_DST_IP=192.168.10.53 # was 192.168.0.51
	NUM_IP_DST=52 # was 50 + 2
	START_SPORT=10100
	END_SPORT=10110
	START_DPORT=8080
	END_DPORT=8184 # was 8178 + 6
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
local test_type=$1
ssh polycube@$REMOTE_DUT "sudo service docker restart"
CONTAINER_ID=$(ssh polycube@$REMOTE_DUT "sudo docker run -id --name bpf-iptables --rm --privileged --network host -v /lib/modules:/lib/modules:ro -v /usr/src:/usr/src:ro -v /etc/localtime:/etc/localtime:ro netgrouppolito/bpf-iptables:latest bash")
ssh polycube@$REMOTE_DUT << EOF
  set -x
  sudo docker exec -d bpf-iptables bash -c "exec -a config_dut $REMOTE_FOLDER/config_dut_routing.sh -s $NUM_IP_SRC -d $NUM_IP_DST > /home/polycube/log 2>&1 &"
  sudo docker exec -d bpf-iptables bash -c "$REMOTE_FOLDER/rulesets/rules_${test_type}.sh $IPTABLES FORWARD"
EOF
if [ ${IPTABLES} == "pcn-iptables"  ]; then
	generate_polycube_config_file
fi
}

function generate_polycube_config_file {
#Create configuration file for polycubectl
ssh polycube@$REMOTE_DUT << EOF
sudo docker exec bpf-iptables bash -c "cat > ${POLYCUBECTL_CONFIG_FILE} << EOF
  debug: false
  expert: true
  url: http://${REMOTE_DUT}:9000/polycube/v1/
  version: "2"
  hardcodedversionenabled: true
  singleparameterworkaround: true
EOF"
EOF
}

function remove_polycube_config_file {
	rm -f ${POLYCUBECTL_CONFIG_FILE}
}

function cleanup_environment {
ssh polycube@$REMOTE_DUT << EOF
  $(typeset -f polycubed_kill_and_wait)
  polycubed_kill_and_wait
  sudo iptables -F FORWARD
  sudo docker exec bpf-iptables bash -c "sudo pkill config_dut"
  sudo docker exec bpf-iptables bash -c $REMOTE_FOLDER/config_dut_routing.sh -s $NUM_IP_SRC -d $NUM_IP_DST -r &> /dev/null" &> /dev/null
  sudo docker stop ${CONTAINER_ID} &> /dev/null
  sudo docker rm -f bpf-iptables
  sudo nft flush table ip filter &> /dev/null
  sudo nft delete table ip filter &> /dev/null
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
  set -x
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
  sudo rmmod xt_tcpudp
  sudo rmmod x_tables
EOF
}

function disable_nft {
ssh polycube@$REMOTE_DUT << EOF
  set -x
  sudo rmmod nft_counter
  sudo rmmod nft_ct
  sudo rmmod nf_tables
EOF
}

function enable_conntrack {
ssh polycube@$REMOTE_DUT << EOF
  set -x
  sudo $REMOTE_CONNTRACK_SCRIPT_FOLDER/enable.sh
EOF

if [ ${IPTABLES} == "pcn-iptables"  ]; then
	remove_polycube_config_file
fi
}

function cleanup {
  set +e
  cleanup_environment
}

# The argument of this function is the range of cores to be used
# or 'all' in case all cores are used
function set_irq_affinity {
local iface_name=$1
ssh polycube@$REMOTE_DUT << EOF
  set -x
  sudo docker exec bpf-iptables bash -c "$SET_IRQ_SCRIPT $2 $iface_name"
EOF
}

# This function extracts the pkt rate from iptables
# or pcn-iptables output.
function extract_rate_from_rules {
set -x
local output_file=$1
local test_type=$2
local result=0

if [ ${IPTABLES} == "iptables"  ]; then
	local dump_file=iptables-dump.${NOW}.${test_type}.txt
	dump_iptables_rules $dump_file
	result=$(awk -f ${DIR}/sum_iptables_output.awk < ${DIR}/${dump_file})
elif [ ${IPTABLES} == "nftables"  ]; then
	local dump_file=nftables-dump.${NOW}.${test_type}.txt
	dump_nftables_rules $dump_file
	result=$(awk -f ${DIR}/sum_nftables_output.awk < ${DIR}/${dump_file})
else
	local dump_file=pcn-iptables-dump.${NOW}.${test_type}.txt
	dump_pcn_iptables_rules $dump_file
	result=$(awk -f ${DIR}/sum_pcn_iptables_output.awk < ${DIR}/${dump_file})
fi

echo "" >> ${output_file}
echo "Number of packets processed: ${result}" >> ${output_file}
echo "Test duration: ${TEST_DURATION}" >> ${output_file}
local final_pps=$(awk "BEGIN {printf \"%.2f\",${result}/${TEST_DURATION}}")
echo "Resulting PPS: ${final_pps}" >> ${output_file}
}

function dump_nftables_rules {
local dump_file=$1
ssh polycube@$REMOTE_DUT << EOF
  set -x
  sudo nft list table filter -a > /tmp/${dump_file}
  scp /tmp/${dump_file} $LOCAL_NAME@$LOCAL_DUT:$DIR/${dump_file}.original
EOF

# Remove empty lines at the end of the file
awk '/^$/ {nlstack=nlstack "\n";next;} {printf "%s",nlstack; nlstack=""; print;}' $DIR/${dump_file}.original > $DIR/${dump_file}
rm -f $DIR/${dump_file}.original
}

function dump_iptables_rules {
local dump_file=$1
ssh polycube@$REMOTE_DUT << EOF
  set -x
  sudo iptables -vxnL FORWARD > /tmp/${dump_file}
  scp /tmp/${dump_file} $LOCAL_NAME@$LOCAL_DUT:$DIR/${dump_file}.original
EOF

# Remove empty lines at the end of the file
awk '/^$/ {nlstack=nlstack "\n";next;} {printf "%s",nlstack; nlstack=""; print;}' $DIR/${dump_file}.original > $DIR/${dump_file}
rm -f $DIR/${dump_file}.original
}

function dump_pcn_iptables_rules {
local dump_file=$1
sudo docker exec bpf-iptables bash -c "polycubectl pcn-iptables chain FORWARD stats show" > ${DIR}/${dump_file}.original

# Remove empty lines at the end of the file
awk '/^$/ {nlstack=nlstack "\n";next;} {printf "%s",nlstack; nlstack=""; print;}' $DIR/${dump_file}.original > $DIR/${dump_file}
rm -f $DIR/${dump_file}.original
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
    testDuration = $(( ${TEST_DURATION} * 1000 )),
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

#reboot_remote_dut

for test_type in "${ruleset_values[@]}"; do
  set +e

  generate_test_configuration $test_type

  set -e
  cleanup

  if [ ${IPTABLES} == "pcn-iptables"  ]; then
    ssh polycube@$REMOTE_DUT "$polycubed --version" > $DIR/"$OUT_FILE-${test_type}.txt"
  elif [ ${IPTABLES} == "iptables"  ]; then
    ssh polycube@$REMOTE_DUT "sudo iptables --version" > $DIR/"$OUT_FILE-${test_type}.txt"
  else 
    ssh polycube@$REMOTE_DUT "sudo nft --version" > $DIR/"$OUT_FILE-${test_type}.txt"
  fi

  echo "Processing type: ${test_type}" >> $DIR/"$OUT_FILE-${test_type}.txt"
  ssh polycube@$REMOTE_DUT "uname -r" >> $DIR/"$OUT_FILE-${test_type}.txt"
  echo "" >> $DIR/"$OUT_FILE-${test_type}.txt"

  ###################################################
  # Execute a multi-core test without binary search #
  ###################################################
  echo "####################################" >> $DIR/"$OUT_FILE-${test_type}.txt"
  echo "# Multi-core without binary search #" >> $DIR/"$OUT_FILE-${test_type}.txt"
  echo "####################################" >> $DIR/"$OUT_FILE-${test_type}.txt"
  START_RATE=25
  echo "Start Rate: ${START_RATE}" >> $DIR/"$OUT_FILE-${test_type}.txt"
  for i in `seq 1 ${NUMBER_RUNS}`; do
	  echo "Run: $i" >> $DIR/"$OUT_FILE-${test_type}.txt"
	  setup_environment $test_type
	  set_irq_affinity $INGRESS_IFACE_NAME "all"
	  set_irq_affinity $EGRESS_IFACE_NAME "all"

	  sleep 5
	  generate_pktgen_config_file 1

	  if [ ${IPTABLES} == "pcn-iptables" ]; then
        disable_conntrack
        disable_nft
      fi

	  cd $PKTGEN_FOLDER
	  sudo ./app/x86_64-native-linuxapp-gcc/pktgen -c ff -n 4 --proc-type auto --file-prefix pg -- -T -P -m "[1:2/3/4/5].0, [6/7].1" -f $DIR/enterprise-public2.lua
	  sleep 5

	  echo "Pktgen-DPDK Output:" >> $DIR/"$OUT_FILE-${test_type}.txt"
	  cat "pcn-iptables-forward.csv" >> $DIR/"$OUT_FILE-${test_type}.txt"
	  extract_rate_from_rules $DIR/"$OUT_FILE-${test_type}.txt" $test_type
	  cleanup_environment
	  sleep 5
	  echo "--------------------------------------------------" >> $DIR/"$OUT_FILE-${test_type}.txt"
	  sleep 30
  done

  cd $DIR
done
ssh polycube@$REMOTE_DUT "sudo service docker restart"
exit 0
