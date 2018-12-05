source "${BASH_SOURCE%/*}/helpers.bash"
# usage:
# rules_xxx.sh [iptables|pcn-iptables] [INPUT|FORWARD]

# set -x
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

NFTABLES_DIR=nftables-rules
IPTABLES="sudo iptables"
CHAIN="INPUT"
REMOTE_IP=10.10.10.2
REMOTE_PORT=80

echo ""
echo "usage:"
echo "$0 [iptables|pcn-iptables|nftables] [FORWARD] [10.10.10.1] [$REMOTE_PORT]"
echo ""

CHAIN=$2
REMOTE_IP=$3
REMOTE_PORT=$4

if [ "$1" == "pcn-iptables" ]; then
    echo "Using bpf-iptables"
    IPTABLES="bpf-iptables"
    launch_pcn_iptables
elif [ "$1" == "nftables" ]; then
    echo "Using nftables"
    IPTABLES="sudo nft"
else
	echo "Using iptables"
    IPTABLES="sudo iptables"
fi



if [ "$1" == "nftables" ]; then
    $IPTABLES add table ip filter
    $IPTABLES add chain ip filter $CHAIN { type filter hook input priority 0 \; }
    $IPTABLES add rule ip filter $CHAIN ct state established counter accept
    $IPTABLES add rule ip filter INPUT ct state new tcp dport $REMOTE_PORT counter accept
    #$IPTABLES add rule ip filter INPUT ip saddr $REMOTE_IP counter drop
else 
    $IPTABLES -F $CHAIN
    $IPTABLES -A $CHAIN -m conntrack --ctstate ESTABLISHED -j ACCEPT
    $IPTABLES -A $CHAIN -m conntrack --ctstate NEW -p tcp --dport $REMOTE_PORT -j ACCEPT
    #$IPTABLES -A $CHAIN -s $REMOTE_IP -j DROP
fi

exit 0
