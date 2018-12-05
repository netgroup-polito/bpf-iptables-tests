#!/bin/bash

START_IP_SRC=(192 168 0 2)

NUM_IP_SRC=40
DELETE_ENTRIES=0

sudo ifconfig enp101s0f0 192.168.0.1/22 up
sudo ifconfig enp101s0f1 10.10.10.1/24 up

#sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

function ip_to_int() {
#Returns the integer representation of an IP arg, passed in ascii dotted-decimal notation (x.x.x.x)
IP=$1; IPNUM=0
for (( i=0 ; i<4 ; ++i )); do
	((IPNUM+=${IP%%.*}*$((256**$((3-${i}))))))
	IP=${IP#*.}
done
echo $IPNUM
}

function int_to_ip() {
#returns the dotted-decimal ascii form of an IP arg passed in integer format
echo -n $(($(($(($((${1}/256))/256))/256))%256)).
echo -n $(($(($((${1}/256))/256))%256)).
echo -n $(($((${1}/256))%256)).
echo $((${1}%256))
}


while getopts :o:s:rh option; do
 case "${option}" in
 h|\?)
	show_help
	exit 0
	;;
 o) OUT_FILE=${OPTARG}
	;;
 s) NUM_IP_SRC=${OPTARG}
	;;
 r) DELETE_ENTRIES=1
	;;
 :)
    echo "Option -$OPTARG requires an argument." >&2
    show_help
    exit 0
    ;;
 esac
done

while true; do
	NEW_IP_SRC=$( IFS=$'.'; echo "${START_IP_SRC[*]}" )
	for i in `seq 1 $NUM_IP_SRC`; do
		if [ $DELETE_ENTRIES -eq 0 ]; then
			sudo arp -s ${NEW_IP_SRC} 3c:fd:fe:af:ec:48
		else
			sudo arp -d ${NEW_IP_SRC}
		fi
		NEW_IP_SRC=$(int_to_ip $(( $(ip_to_int $NEW_IP_SRC)+1 )))
	done
	
	if [ $DELETE_ENTRIES -eq 1 ]; then
		break
	fi
	sleep 25
done
