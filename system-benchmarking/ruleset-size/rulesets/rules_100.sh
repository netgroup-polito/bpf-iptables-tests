source "${BASH_SOURCE%/*}/helpers.bash"

# usage:
# rules_xxx.sh [iptables|pcn-iptables] [INPUT|FORWARD]

# set -x
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

NFTABLES_DIR=nftables-rules
IPTABLES="sudo iptables"
CHAIN="FORWARD"

echo ""
echo "usage:"
echo "$0 [iptables|pcn-iptables|nftables] [FORWARD]"
echo ""

if [ "$1" == "pcn-iptables" ]; then
    echo "Using bpf-iptables"
    IPTABLES="bpf-iptables"
    launch_pcn_iptables
elif [ "$1" == "nftables" ]; then
    echo "Using nftables"
    IPTABLES="nft"
else
	echo "Using iptables"
    IPTABLES="sudo iptables"
fi

if [ "$1" == "nftables" ]; then
	echo "Loading nftables rules"
	export CHAIN
	exec $DIR/$NFTABLES_DIR/nftables_100.sh
	exit 0
elif [ "$1" == "pcn-iptables" ]; then
	polycubectl pcn-iptables set interactive=false
else
    $IPTABLES -A $CHAIN -m conntrack --ctstate ESTABLISHED -j ACCEPT
    $IPTABLES -F $CHAIN
fi

$IPTABLES -P $CHAIN DROP
$IPTABLES -A $CHAIN -s 192.168.0.2 -d 192.168.1.2 -p udp --sport 10100 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.2 -d 192.168.1.2 -p udp --sport 10100 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.2 -d 192.168.1.2 -p udp --sport 10101 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.2 -d 192.168.1.2 -p udp --sport 10101 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.2 -d 192.168.1.3 -p udp --sport 10100 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.2 -d 192.168.1.3 -p udp --sport 10100 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.2 -d 192.168.1.3 -p udp --sport 10101 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.2 -d 192.168.1.3 -p udp --sport 10101 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.2 -d 192.168.1.4 -p udp --sport 10100 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.2 -d 192.168.1.4 -p udp --sport 10100 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.2 -d 192.168.1.4 -p udp --sport 10101 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.2 -d 192.168.1.4 -p udp --sport 10101 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.2 -d 192.168.1.5 -p udp --sport 10100 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.2 -d 192.168.1.5 -p udp --sport 10100 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.2 -d 192.168.1.5 -p udp --sport 10101 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.2 -d 192.168.1.5 -p udp --sport 10101 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.2 -d 192.168.1.6 -p udp --sport 10100 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.2 -d 192.168.1.6 -p udp --sport 10100 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.2 -d 192.168.1.6 -p udp --sport 10101 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.2 -d 192.168.1.6 -p udp --sport 10101 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.3 -d 192.168.1.2 -p udp --sport 10100 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.3 -d 192.168.1.2 -p udp --sport 10100 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.3 -d 192.168.1.2 -p udp --sport 10101 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.3 -d 192.168.1.2 -p udp --sport 10101 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.3 -d 192.168.1.3 -p udp --sport 10100 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.3 -d 192.168.1.3 -p udp --sport 10100 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.3 -d 192.168.1.3 -p udp --sport 10101 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.3 -d 192.168.1.3 -p udp --sport 10101 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.3 -d 192.168.1.4 -p udp --sport 10100 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.3 -d 192.168.1.4 -p udp --sport 10100 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.3 -d 192.168.1.4 -p udp --sport 10101 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.3 -d 192.168.1.4 -p udp --sport 10101 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.3 -d 192.168.1.5 -p udp --sport 10100 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.3 -d 192.168.1.5 -p udp --sport 10100 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.3 -d 192.168.1.5 -p udp --sport 10101 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.3 -d 192.168.1.5 -p udp --sport 10101 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.3 -d 192.168.1.6 -p udp --sport 10100 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.3 -d 192.168.1.6 -p udp --sport 10100 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.3 -d 192.168.1.6 -p udp --sport 10101 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.3 -d 192.168.1.6 -p udp --sport 10101 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.4 -d 192.168.1.2 -p udp --sport 10100 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.4 -d 192.168.1.2 -p udp --sport 10100 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.4 -d 192.168.1.2 -p udp --sport 10101 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.4 -d 192.168.1.2 -p udp --sport 10101 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.4 -d 192.168.1.3 -p udp --sport 10100 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.4 -d 192.168.1.3 -p udp --sport 10100 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.4 -d 192.168.1.3 -p udp --sport 10101 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.4 -d 192.168.1.3 -p udp --sport 10101 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.4 -d 192.168.1.4 -p udp --sport 10100 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.4 -d 192.168.1.4 -p udp --sport 10100 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.4 -d 192.168.1.4 -p udp --sport 10101 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.4 -d 192.168.1.4 -p udp --sport 10101 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.4 -d 192.168.1.5 -p udp --sport 10100 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.4 -d 192.168.1.5 -p udp --sport 10100 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.4 -d 192.168.1.5 -p udp --sport 10101 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.4 -d 192.168.1.5 -p udp --sport 10101 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.4 -d 192.168.1.6 -p udp --sport 10100 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.4 -d 192.168.1.6 -p udp --sport 10100 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.4 -d 192.168.1.6 -p udp --sport 10101 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.4 -d 192.168.1.6 -p udp --sport 10101 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.5 -d 192.168.1.2 -p udp --sport 10100 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.5 -d 192.168.1.2 -p udp --sport 10100 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.5 -d 192.168.1.2 -p udp --sport 10101 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.5 -d 192.168.1.2 -p udp --sport 10101 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.5 -d 192.168.1.3 -p udp --sport 10100 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.5 -d 192.168.1.3 -p udp --sport 10100 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.5 -d 192.168.1.3 -p udp --sport 10101 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.5 -d 192.168.1.3 -p udp --sport 10101 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.5 -d 192.168.1.4 -p udp --sport 10100 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.5 -d 192.168.1.4 -p udp --sport 10100 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.5 -d 192.168.1.4 -p udp --sport 10101 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.5 -d 192.168.1.4 -p udp --sport 10101 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.5 -d 192.168.1.5 -p udp --sport 10100 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.5 -d 192.168.1.5 -p udp --sport 10100 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.5 -d 192.168.1.5 -p udp --sport 10101 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.5 -d 192.168.1.5 -p udp --sport 10101 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.5 -d 192.168.1.6 -p udp --sport 10100 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.5 -d 192.168.1.6 -p udp --sport 10100 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.5 -d 192.168.1.6 -p udp --sport 10101 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.5 -d 192.168.1.6 -p udp --sport 10101 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.6 -d 192.168.1.2 -p udp --sport 10100 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.6 -d 192.168.1.2 -p udp --sport 10100 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.6 -d 192.168.1.2 -p udp --sport 10101 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.6 -d 192.168.1.2 -p udp --sport 10101 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.6 -d 192.168.1.3 -p udp --sport 10100 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.6 -d 192.168.1.3 -p udp --sport 10100 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.6 -d 192.168.1.3 -p udp --sport 10101 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.6 -d 192.168.1.3 -p udp --sport 10101 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.6 -d 192.168.1.4 -p udp --sport 10100 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.6 -d 192.168.1.4 -p udp --sport 10100 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.6 -d 192.168.1.4 -p udp --sport 10101 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.6 -d 192.168.1.4 -p udp --sport 10101 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.6 -d 192.168.1.5 -p udp --sport 10100 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.6 -d 192.168.1.5 -p udp --sport 10100 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.6 -d 192.168.1.5 -p udp --sport 10101 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.6 -d 192.168.1.5 -p udp --sport 10101 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.6 -d 192.168.1.6 -p udp --sport 10100 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.6 -d 192.168.1.6 -p udp --sport 10100 --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.6 -d 192.168.1.6 -p udp --sport 10101 --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -s 192.168.0.6 -d 192.168.1.6 -p udp --sport 10101 --dport 8081 -j ACCEPT

if [ "$1" == "pcn-iptables" ];
then
    polycubectl pcn-iptables chain $CHAIN apply-rules
fi
