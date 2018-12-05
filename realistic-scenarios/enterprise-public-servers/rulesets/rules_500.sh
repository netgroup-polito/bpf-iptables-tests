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
    exec $DIR/$NFTABLES_DIR/nftables_500.sh
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
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.12 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.13 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.14 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.15 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.16 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.17 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.18 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.19 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.20 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.21 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.22 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.23 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.24 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.25 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.26 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.27 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.28 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.29 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.30 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.31 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.32 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.33 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.34 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.35 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.36 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.37 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.38 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.39 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.40 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.41 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.42 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.43 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.44 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.45 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.46 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.47 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.48 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.49 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.50 -j ACCEPT
$IPTABLES -A $CHAIN -m conntrack --ctstate NEW -s 192.168.10.51 -j ACCEPT
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
$IPTABLES -A $CHAIN -d 192.168.10.12 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.12 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.12 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.12 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.12 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.12 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.12 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.12 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.12 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.13 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.13 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.13 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.13 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.13 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.13 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.13 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.13 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.13 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.14 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.14 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.14 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.14 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.14 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.14 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.14 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.14 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.14 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.15 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.15 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.15 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.15 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.15 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.15 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.15 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.15 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.15 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.16 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.16 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.16 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.16 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.16 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.16 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.16 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.16 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.16 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.17 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.17 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.17 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.17 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.17 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.17 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.17 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.17 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.17 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.18 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.18 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.18 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.18 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.18 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.18 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.18 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.18 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.18 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.19 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.19 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.19 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.19 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.19 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.19 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.19 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.19 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.19 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.20 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.20 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.20 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.20 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.20 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.20 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.20 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.20 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.20 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.21 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.21 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.21 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.21 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.21 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.21 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.21 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.21 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.21 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.22 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.22 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.22 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.22 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.22 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.22 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.22 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.22 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.22 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.23 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.23 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.23 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.23 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.23 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.23 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.23 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.23 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.23 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.24 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.24 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.24 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.24 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.24 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.24 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.24 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.24 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.24 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.25 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.25 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.25 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.25 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.25 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.25 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.25 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.25 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.25 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.26 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.26 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.26 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.26 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.26 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.26 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.26 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.26 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.26 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.27 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.27 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.27 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.27 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.27 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.27 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.27 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.27 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.27 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.28 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.28 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.28 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.28 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.28 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.28 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.28 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.28 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.28 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.29 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.29 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.29 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.29 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.29 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.29 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.29 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.29 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.29 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.30 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.30 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.30 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.30 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.30 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.30 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.30 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.30 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.30 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.31 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.31 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.31 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.31 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.31 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.31 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.31 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.31 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.31 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.32 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.32 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.32 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.32 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.32 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.32 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.32 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.32 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.32 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.33 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.33 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.33 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.33 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.33 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.33 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.33 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.33 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.33 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.34 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.34 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.34 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.34 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.34 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.34 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.34 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.34 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.34 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.35 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.35 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.35 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.35 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.35 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.35 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.35 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.35 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.35 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.36 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.36 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.36 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.36 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.36 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.36 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.36 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.36 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.36 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.37 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.37 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.37 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.37 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.37 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.37 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.37 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.37 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.37 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.38 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.38 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.38 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.38 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.38 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.38 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.38 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.38 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.38 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.39 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.39 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.39 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.39 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.39 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.39 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.39 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.39 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.39 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.40 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.40 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.40 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.40 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.40 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.40 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.40 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.40 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.40 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.41 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.41 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.41 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.41 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.41 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.41 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.41 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.41 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.41 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.42 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.42 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.42 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.42 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.42 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.42 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.42 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.42 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.42 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.43 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.43 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.43 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.43 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.43 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.43 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.43 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.43 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.43 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.44 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.44 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.44 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.44 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.44 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.44 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.44 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.44 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.44 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.45 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.45 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.45 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.45 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.45 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.45 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.45 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.45 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.45 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.46 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.46 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.46 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.46 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.46 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.46 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.46 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.46 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.46 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.47 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.47 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.47 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.47 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.47 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.47 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.47 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.47 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.47 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.48 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.48 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.48 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.48 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.48 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.48 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.48 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.48 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.48 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.49 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.49 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.49 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.49 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.49 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.49 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.49 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.49 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.49 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.50 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.50 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.50 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.50 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.50 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.50 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.50 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.50 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.50 -p udp --dport 8088 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.51 -p udp --dport 8080 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.51 -p udp --dport 8081 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.51 -p udp --dport 8082 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.51 -p udp --dport 8083 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.51 -p udp --dport 8084 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.51 -p udp --dport 8085 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.51 -p udp --dport 8086 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.51 -p udp --dport 8087 -j ACCEPT
$IPTABLES -A $CHAIN -d 192.168.10.51 -p udp --dport 8088 -j ACCEPT

if [ "$1" == "pcn-iptables" ];
then
    polycubectl pcn-iptables chain $CHAIN apply-rules
fi
