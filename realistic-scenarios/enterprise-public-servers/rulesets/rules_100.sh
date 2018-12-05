source "${BASH_SOURCE%/*}/helpers.bash"

# set -x
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

NFTABLES_DIR=nftables-rules
IPTABLES="$1"
CHAIN="$2"

if [ -z ${IPTABLES} ]; then
    echo ""
    echo "usage:"
    echo "$0 [iptables|pcn-iptables|nftables] [FORWARD]"
    echo ""
    exit 0
fi

if [ -z ${CHAIN} ]; then
    echo ""
    echo "usage:"
    echo "$0 [iptables|pcn-iptables|nftables] [FORWARD]"
    echo ""
    exit 0
fi

if [ "$1" == "pcn-iptables" ]; then
    echo "Using bpf-iptables"
    IPTABLES="bpf-iptables"
    launch_pcn_iptables
elif [ "$1" == "nftables" ]; then
    echo "Using nftables"
    IPTABLES="nft"
elif [ "$1" == "iptables" ]; then
    echo "Using iptables"
    IPTABLES="sudo iptables"
else
	echo "$1 is not supported"
	exit 1
fi

if [ "$1" == "nftables" ]; then
    echo "Loading nftables rules"
    export CHAIN
    exec $DIR/$NFTABLES_DIR/nftables_100.sh
    exit 0
elif [ "$1" == "pcn-iptables" ]; then
    pcn-iptables -F $CHAIN
    polycubectl pcn-iptables set interactive=false
else
    $IPTABLES -F $CHAIN
fi

$IPTABLES -P $CHAIN DROP
$IPTABLES -A $CHAIN -m conntrack --ctstate ESTABLISHED -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.2 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.3 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.4 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.5 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.6 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.7 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.8 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.9 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.10 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.11 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.2 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.2 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.2 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.2 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.2 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.2 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.2 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.2 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.2 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.3 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.3 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.3 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.3 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.3 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.3 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.3 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.3 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.3 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.4 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.4 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.4 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.4 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.4 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.4 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.4 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.4 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.4 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.5 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.5 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.5 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.5 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.5 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.5 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.5 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.5 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.5 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.6 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.6 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.6 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.6 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.6 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.6 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.6 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.6 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.6 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.7 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.7 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.7 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.7 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.7 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.7 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.7 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.7 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.7 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.8 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.8 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.8 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.8 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.8 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.8 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.8 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.8 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.8 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.9 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.9 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.9 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.9 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.9 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.9 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.9 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.9 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.9 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.10 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.10 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.10 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.10 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.10 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.10 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.10 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.10 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.10 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.11 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.11 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.11 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.11 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.11 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.11 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.11 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.11 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.11 -p udp --dport 8088 -j ACCEPT

if [ "$1" == "pcn-iptables" ];
then
    polycubectl pcn-iptables chain $CHAIN apply-rules
fi
