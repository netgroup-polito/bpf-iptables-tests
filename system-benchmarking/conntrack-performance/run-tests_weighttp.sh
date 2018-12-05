#!/bin/bash

# This test requires an nginx server on the remote DUT. We suggest to set the following
# parameters on both the remote and local server in order to prevent the consumption
# of ephimeral ports.
# For this test we use wrk (https://github.com/wg/wrk), a HTTP benchmarking tool
#
# To make this script work correctly you need to increase the limit of file descriptor
# opened by a single process, so we can stress the conntrack table.
# You can execute the following commands to do this:
# The modification below works after a reboot (if an user is logged):
#    sudo nano /etc/security/limits.conf
#      * soft nofile 200000
#      * hard nofile 200000
#
# If you are logged as 'root' in a terminal, type (instant effect):
#    ulimit -HSn 200000
#
# sudo nano /etc/sysctl.conf
#   net.core.netdev_max_backlog = 400000
#   net.ipv4.ip_local_port_range = 1024 65535
#   net.ipv4.tcp_max_syn_backlog = 12000
#   net.ipv4.tcp_wmem = 30000000 30000000 30000000
#   net.ipv4.tcp_tw_reuse = 1
#
# To apply the configuration, type:
#    sudo sysctl -p /etc/sysctl.conf

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
NOW=$(date +"%m-%d-%Y-%T")

# Remote configurations (DUT)
REMOTE_DUT=IPADDRESS
REMOTE_FOLDER="~/bpf-iptables-tests/system-benchmarking/conntrack-performance"
INGRESS_REMOTE_IFACE_NAME="enp101s0f0"
REMOTE_SERVER_ADDR=10.10.10.1
REMOTE_SERVER_PORT=80
REMOTE_SERVER_FILE=static_file # 100Byte file places in the server
SET_IRQ_SCRIPT="~/bpf-iptables-tests/common-scripts/set_irq_affinity"

polycubed="sudo polycubed"
polycubectl="$GOPATH/bin/polycubectl"

# Local configurations (Pkt generator)
POLYCUBE_VERSION="none"
INGRESS_LOCAL_IFACE_NAME="enp1s0f0"
LOCAL_CLIENT_ADDR=10.10.10.2
IPTABLES="pcn-iptables"
LOCAL_NAME=cube1
LOCAL_DUT=IPADDRESS

TEST_DURATION=30s
TEST_START_RANGE=1
TEST_END_RANGE=1000
TEST_STEP=10

function show_help() {
usage="$(basename "$0") [-h] [-r #runs] [-o output_file] [-d duration][-i|-n]
Run tests of pcn-iptables for the FORWARD chain with a different number of rules

where:
    -h  show this help text
    -r  number of runs for the test
    -o  path to file where the results are placed
    -d  duration of the test, e.g. 2s, 2m, 2h
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

function check_ping {
local result='failed'
ping -c 1 10.10.10.1 > /dev/null 2>&1

if [ $? -eq 0 ]; then
  result='success'
else
  result='failed'
fi
echo "$result"
}

function setup_environment {
sudo ifconfig $INGRESS_LOCAL_IFACE_NAME $LOCAL_CLIENT_ADDR/24 up
ssh polycube@$REMOTE_DUT "sudo service docker restart"
ssh polycube@$REMOTE_DUT << EOF
  set -x
  sudo service nginx restart
  sudo ifconfig $INGRESS_REMOTE_IFACE_NAME $REMOTE_SERVER_ADDR/24 up
  sudo sysctl -p /etc/sysctl.conf
EOF
}

function load_rules {
CONTAINER_ID=$(ssh polycube@$REMOTE_DUT "sudo docker run -id --name bpf-iptables --rm --privileged --network host -v /lib/modules:/lib/modules:ro -v /usr/src:/usr/src:ro -v /etc/localtime:/etc/localtime:ro netgrouppolito/bpf-iptables:latest bash")
ssh polycube@$REMOTE_DUT << EOF
  set -x
  sudo docker exec bpf-iptables bash -c "$REMOTE_FOLDER/rulesets/conntrack_rules.sh $IPTABLES INPUT $LOCAL_CLIENT_ADDR $REMOTE_SERVER_PORT"
EOF
}

function cleanup_environment {
ssh polycube@$REMOTE_DUT << EOF
  $(typeset -f polycubed_kill_and_wait)
  polycubed_kill_and_wait
  sudo iptables -F INPUT
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

function cleanup {
  set +e
  cleanup_environment
}

function calculate_range {
#set +x
local var1=$( echo "scale=2; l($1)/l(10)" | bc -l )
local var2=$( echo "scale=2; l($2)/l(10)" | bc -l )
let exp=mod=result=exp2=0
var1=$( echo "scale=2; $var1*10" | bc )
var2=$( echo "scale=2; $var2*10 + 1.0" | bc )
var1=$(( ${var1%.*} + 0 ))
var2=$(( ${var2%.*} + 0 ))

if [ $var1 -eq 0 ]; then
  var1=1;
fi

for x in `seq ${var1} ${var2}`; do
  exp=$((x/10))
  exp=$(( ${exp%.*} + 0 ))
  mod=$(($x%10))
  if [ $mod -eq 0 ]; then
    continue
  fi
  exp2=$((10**exp))
  result=$((mod*exp2))
  test_range[$x]=$result
done
}

function calculate_range2 {
local start=$1
local end=$2
local step=$3
local i=1;

for x in `seq ${start} ${step} ${end}`; do
  test_range[$i]=$x
  (( i++ ))
done
}

# The argument of this function is the range of cores to be used
# or 'all' in case all cores are used
function set_irq_affinity {
ssh polycube@$REMOTE_DUT << EOF
  set -x
  sudo docker exec bpf-iptables bash -c "$SET_IRQ_SCRIPT $1 $INGRESS_REMOTE_IFACE_NAME"
EOF
}

#set -e

while getopts :r:o:d:inh option; do
 case "${option}" in
 h|\?)
	show_help
	exit 0
	;;
 r) NUMBER_RUNS=${OPTARG}
	;;
 o) OUT_FILE=${OPTARG}
	;;
 d) TEST_DURATION=${OPTARG}
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

set -e
cleanup

if [ ${IPTABLES} == "pcn-iptables"  ]; then
  ssh polycube@$REMOTE_DUT "$polycubed --version" > $DIR/"$OUT_FILE.txt"
elif [ ${IPTABLES} == "iptables"  ]; then
  ssh polycube@$REMOTE_DUT "sudo iptables --version" > $DIR/"$OUT_FILE.txt"
else
  ssh polycube@$REMOTE_DUT "sudo nft --version" > $DIR/"$OUT_FILE.txt"
fi

test_range=()
calculate_range $TEST_START_RANGE $TEST_END_RANGE $TEST_STEP

set -x
for run in `seq 1 $NUMBER_RUNS`; do
  echo "Run Number: $run" >> $DIR/"$OUT_FILE.txt"
  ssh polycube@$REMOTE_DUT "uname -r" >> $DIR/"$OUT_FILE.txt"
  echo "" >> $DIR/"$OUT_FILE.txt"

  cleanup_environment

  echo "#####################################################" >> $DIR/"$OUT_FILE.txt"
  echo "# Execute the first test with interrupts set to all #" >> $DIR/"$OUT_FILE.txt"
  echo "#####################################################" >> $DIR/"$OUT_FILE.txt"

  echo "Number of clients, Requests per second" |& tee -a $DIR/"$OUT_FILE.txt"
  for range_value in "${test_range[@]}"; do
    setup_environment
    set_irq_affinity "all"

    result_ping=$(check_ping)
    if [ ${result_ping} == "failed" ]; then
  	echo "Ping failed. Test aborted..."
        exit 1
    fi

    load_rules
    #if [ $IPTABLES == "pcn-iptables" ]; then
    #  disable_nft
    #  disable_conntrack
    #fi

    sleep 5

    if [ $range_value -lt 8 ]; then
      THREAD_COUNT=$range_value
    else
      THREAD_COUNT=8
    fi

    if [ $range_value -eq 0 ]; then
      range_value=1
      THREAD_COUNT=1
    fi

    if [ $range_value -gt $TEST_END_RANGE ]; then
      echo "Done! Closing..."
      break
    fi

    set_irq_affinity "all"
    weighttp -n 1000000 -c $range_value -t $THREAD_COUNT http://$REMOTE_SERVER_ADDR:$REMOTE_SERVER_PORT/$REMOTE_SERVER_FILE &> /tmp/weighttp_output.txt
    num_lines=$(awk 'END{print NR}' /tmp/weighttp_output.txt)
    num_lines=$(( $num_lines-3 ))
    conn_sec=$(awk 'NR=='$num_lines'{print $10}' /tmp/weighttp_output.txt)
    echo "$range_value, $conn_sec" |& tee -a $DIR/"$OUT_FILE.txt"

    cleanup_environment
    sleep 120
  done

  cleanup_environment

  echo "#########################################################" >> $DIR/"$OUT_FILE.txt"
  echo "# Execute the first test with interrupts set to core #2 #" >> $DIR/"$OUT_FILE.txt"
  echo "#########################################################" >> $DIR/"$OUT_FILE.txt"

  echo "Number of clients, Requests per second" |& tee -a $DIR/"$OUT_FILE.txt"
  for range_value in "${test_range[@]}"; do
    setup_environment
    set_irq_affinity "1"

    result_ping=$(check_ping)
    if [ ${result_ping} == "failed" ]; then
  	echo "Ping failed. Test aborted..."
        exit 1
    fi

    load_rules
    #if [ $IPTABLES == "pcn-iptables" ]; then
    #  disable_conntrack
    #  disable_nft
    #fi

    sleep 5

    if [ $range_value -lt 8 ]; then
      THREAD_COUNT=$range_value
    else
      THREAD_COUNT=8
    fi

    if [ $range_value -eq 0 ]; then
      range_value=1
      THREAD_COUNT=1
    fi

    if [ $range_value -gt $TEST_END_RANGE ]; then
      echo "Done! Closing..."
      break
    fi

    set_irq_affinity "1"
    weighttp -n 1000000 -c $range_value -t $THREAD_COUNT http://$REMOTE_SERVER_ADDR:$REMOTE_SERVER_PORT/$REMOTE_SERVER_FILE &> /tmp/weighttp_output.txt
    num_lines=$(awk 'END{print NR}' /tmp/weighttp_output.txt)
    num_lines=$(( $num_lines-3 ))
    conn_sec=$(awk 'NR=='$num_lines'{print $10}' /tmp/weighttp_output.txt)
    echo "$range_value, $conn_sec" |& tee -a $DIR/"$OUT_FILE.txt"

    cleanup_environment
    sleep 120
  done

  sleep 15
done

ssh polycube@$REMOTE_DUT "sudo service docker restart"
exit 0
