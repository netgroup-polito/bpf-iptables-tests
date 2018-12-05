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
  exec $DIR/$NFTABLES_DIR/nftables_50.sh
  exit 0
elif [ "$1" == "pcn-iptables" ]; then
  polycubectl pcn-iptables set interactive=false
else
    $IPTABLES -A $CHAIN -m conntrack --ctstate ESTABLISHED -j ACCEPT
    $IPTABLES -F $CHAIN
fi

$IPTABLES -P $CHAIN ACCEPT

if [ "$1" == "pcn-iptables" ];
then
    polycubectl pcn-iptables chain $CHAIN apply-rules
fi
