#!/bin/bash

RULESET_SIZE=1000

START_IP_SRC=(192 168 0 2)
START_IP_DST=(192 168 10 2)
START_PORT_SRC=10100
START_PORT_DST=8090
PROTO="udp"

NUM_IP_SRC=10
NUM_IP_DST=5
NUM_PORT_SRC=4
NUM_PORT_DST=5

USE_IP_SRC=0
USE_IP_DST=0
USE_PORT_SRC=0
USE_PORT_DST=0
USE_PROTO=0

function show_help() {
usage="$(basename "$0") [-h] [-o output_file]
Creates a ruleset containing all possible combinations of IPsrc/dst and PortSrc/dst

where:
    -h  show this help text
    -s  use IP source addresses
    -d  use IP destination addresses
    -a  use Port source numbers
    -b  use Port destination numbers
    -p  protocol type (default udp)
    -o  path to file where the results are placed"

echo "$usage"
}

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


while getopts :o:sdabph option; do
 case "${option}" in
 h|\?)
	show_help
	exit 0
	;;
 o) OUT_FILE=${OPTARG}
	;;
 s) USE_IP_SRC=1
	;;
 d) USE_IP_DST=1
	;;
 a) USE_PORT_SRC=1
	;;
 b) USE_PORT_DST=1
	;;
 p) USE_PROTO=1
	;;
 :)
    echo "Option -$OPTARG requires an argument." >&2
    show_help
    exit 0
    ;;
 esac
done

if [ -z ${OUT_FILE+x} ]; then
	echo "You should specify the output file with the -o option" >&2;
	show_help
	exit 0
fi

rm -f output.txt > /dev/null

OLD_IP_SRC=("${START_IP_SRC[@]}")
OLD_IP_DST=("${START_IP_DST[@]}")
OLD_PORT_SRC=${START_PORT_SRC}
OLD_PORT_DST=${START_PORT_DST}

###################
# Use only IP_SRC #
###################

if [ $USE_IP_SRC -eq 1 ] && [ $USE_IP_DST -eq 0 ] && [ $USE_PORT_SRC -eq 0 ] && [ $USE_PORT_DST -eq 0 ] && [ $USE_PROTO -eq 0 ]
then
	echo "NUM_IP_SRC: ${NUM_IP_SRC}"
	echo ""
	echo "Generating rules..."
	
	echo "\$IPTABLES -P \$CHAIN DROP" > ${OUT_FILE}
	NEW_IP_SRC=$( IFS=$'.'; echo "${START_IP_SRC[*]}" )
	for i in `seq 1 $RULESET_SIZE`; do
		echo "\$IPTABLES -A \$CHAIN -s ${NEW_IP_SRC} -j ACCEPT" >> ${OUT_FILE}
		NEW_IP_SRC=$(int_to_ip $(( $(ip_to_int $NEW_IP_SRC)+1 )))
	done
fi

######################
# Use IP_SRC, IP_DST #
######################

if [ $USE_IP_SRC -eq 1 ] && [ $USE_IP_DST -eq 1 ] && [ $USE_PORT_SRC -eq 0 ] && [ $USE_PORT_DST -eq 0 ] && [ $USE_PROTO -eq 0 ]
then
	NUM_IP_SRC=40
	NUM_IP_DST=25

	echo "NUM_IP_SRC: ${NUM_IP_SRC}"
	echo "NUM_IP_DST: ${NUM_IP_DST}"
	echo ""
	echo "Generating rules..."
	
	echo "\$IPTABLES -P \$CHAIN DROP" > ${OUT_FILE}
	NEW_IP_SRC=$( IFS=$'.'; echo "${START_IP_SRC[*]}" )
	for i in `seq 1 $NUM_IP_SRC`; do
		NEW_IP_DST=$( IFS=$'.'; echo "${START_IP_DST[*]}" )
		for j in `seq 1 $NUM_IP_DST`; do
			echo "\$IPTABLES -A \$CHAIN -s ${NEW_IP_SRC} -d ${NEW_IP_DST} -j ACCEPT" >> ${OUT_FILE}
			NEW_IP_DST=$(int_to_ip $(( $(ip_to_int $NEW_IP_DST)+1 )))
		done
		NEW_IP_SRC=$(int_to_ip $(( $(ip_to_int $NEW_IP_SRC)+1 )))
	done
fi

#############################
# Use IP_SRC, IP_DST, PROTO #
#############################

if [ $USE_IP_SRC -eq 1 ] && [ $USE_IP_DST -eq 1 ] && [ $USE_PORT_SRC -eq 0 ] && [ $USE_PORT_DST -eq 0 ] && [ $USE_PROTO -eq 1 ]
then
	NUM_IP_SRC=40
	NUM_IP_DST=25

	echo "NUM_IP_SRC: ${NUM_IP_SRC}"
	echo "NUM_IP_DST: ${NUM_IP_DST}"
	echo ""
	echo "Generating rules..."
	
	echo "\$IPTABLES -P \$CHAIN DROP" > ${OUT_FILE}
	NEW_IP_SRC=$( IFS=$'.'; echo "${START_IP_SRC[*]}" )
	for i in `seq 1 $NUM_IP_SRC`; do
		NEW_IP_DST=$( IFS=$'.'; echo "${START_IP_DST[*]}" )
		for j in `seq 1 $NUM_IP_DST`; do
			echo "\$IPTABLES -A \$CHAIN -s ${NEW_IP_SRC} -d ${NEW_IP_DST} -p ${PROTO} -j ACCEPT" >> ${OUT_FILE}
			NEW_IP_DST=$(int_to_ip $(( $(ip_to_int $NEW_IP_DST)+1 )))
		done
		NEW_IP_SRC=$(int_to_ip $(( $(ip_to_int $NEW_IP_SRC)+1 )))
	done
fi

#######################################
# Use IP_SRC, IP_DST, PROTO, PORT_SRC #
#######################################

if [ $USE_IP_SRC -eq 1 ] && [ $USE_IP_DST -eq 1 ] && [ $USE_PORT_SRC -eq 1 ] && [ $USE_PORT_DST -eq 0 ] && [ $USE_PROTO -eq 1 ]
then
	NUM_IP_SRC=10
	NUM_IP_DST=10
	NUM_PORT_SRC=10

	echo "NUM_IP_SRC: ${NUM_IP_SRC}"
	echo "NUM_IP_DST: ${NUM_IP_DST}"
	echo "NUM_PORT_SRC: ${NUM_PORT_SRC}"
	echo ""
	echo "Generating rules..."

	echo "\$IPTABLES -P \$CHAIN DROP" > ${OUT_FILE}
	NEW_IP_SRC=$( IFS=$'.'; echo "${START_IP_SRC[*]}" )
	for i in `seq 1 $NUM_IP_SRC`; do
		NEW_IP_DST=$( IFS=$'.'; echo "${START_IP_DST[*]}" )
		for j in `seq 1 $NUM_IP_DST`; do
			NEW_PORT_SRC=${START_PORT_SRC}
			for k in `seq 1 $NUM_IP_DST`; do 
				echo "\$IPTABLES -A \$CHAIN -s ${NEW_IP_SRC} -d ${NEW_IP_DST} -p ${PROTO} --sport ${NEW_PORT_SRC} -j ACCEPT" >> ${OUT_FILE}
				NEW_PORT_SRC=$(( NEW_PORT_SRC+1 ))
			done
			NEW_IP_DST=$(int_to_ip $(( $(ip_to_int $NEW_IP_DST)+1 )))
		done
		NEW_IP_SRC=$(int_to_ip $(( $(ip_to_int $NEW_IP_SRC)+1 )))
	done
fi

#################################################
# Use IP_SRC, IP_DST, PROTO, PORT_SRC, PORT_DST #
#################################################

if [ $USE_IP_SRC -eq 1 ] && [ $USE_IP_DST -eq 1 ] && [ $USE_PORT_SRC -eq 1 ] && [ $USE_PORT_DST -eq 1 ] && [ $USE_PROTO -eq 1 ]
then
	echo "NUM_IP_SRC: ${NUM_IP_SRC}"
	echo "NUM_IP_DST: ${NUM_IP_DST}"
	echo "NUM_PORT_SRC: ${NUM_PORT_SRC}"
	echo "NUM_PORT_DST: ${NUM_PORT_DST}"
	echo ""
	echo "Generating rules..."
	
	echo "\$IPTABLES -P \$CHAIN DROP" > ${OUT_FILE}
	for i in `seq 1 $NUM_IP_SRC`; do
		NEW_IP_SRC=$( IFS=$'.'; echo "${START_IP_SRC[*]}" )
		for j in `seq 1 $NUM_IP_DST`; do
			NEW_IP_DST=$( IFS=$'.'; echo "${START_IP_DST[*]}" )
			for k in `seq 1 $NUM_PORT_SRC`; do
				for z in `seq 1 $NUM_PORT_DST`; do
					echo "\$IPTABLES -A \$CHAIN -s ${NEW_IP_SRC} -d ${NEW_IP_DST} -p ${PROTO} --sport ${START_PORT_SRC} --dport ${START_PORT_DST} -j ACCEPT" >> ${OUT_FILE}
					(( START_PORT_DST++ ))
				done
				START_PORT_DST=${OLD_PORT_DST}
				(( START_PORT_SRC++ ))
			done
			START_PORT_SRC=${OLD_PORT_SRC}
			(( START_IP_DST[-1]++ ))
		done
		START_IP_DST=("${OLD_IP_DST[@]}")
		(( START_IP_SRC[-1]++ ))
	done
fi

echo "Done. Output in file ${OUT_FILE}"