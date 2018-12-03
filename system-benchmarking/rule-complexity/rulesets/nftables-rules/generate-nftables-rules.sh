#!/bin/bash

#set -x

RULES_DIR=$HOME/iovnet-testing/pcn-iptables/paper-tests/system-benchmarking/rule-complexity/rulesets/generated-rules
FINAL_DIR=$HOME/iovnet-testing/pcn-iptables/paper-tests/system-benchmarking/rule-complexity/rulesets/nftables-rules

for filename in $RULES_DIR/*; do
	basename=$(basename "$filename")
	type=$(echo $basename | cut -d'_' -f2- )
	echo "#!/bin/bash" > $FINAL_DIR/nftables_${type}.sh
	echo "" >> $FINAL_DIR/nftables_${type}.sh
	echo "nft add table ip filter" >> $FINAL_DIR/nftables_${type}.sh
	echo "nft add chain filter \$CHAIN \{ type filter hook forward priority 0\; policy drop\; \}" >> $FINAL_DIR/nftables_${type}.sh
	while IFS= read -r line; do
		new_line=$(echo "$line" | awk '{first = $1; $1 = ""; print $0; }')
    	iptables-translate $new_line >> $FINAL_DIR/nftables_${type}.sh
	done < <(tail -n "+2" $filename)
	echo "Created nftables_${type}.sh"
done

exit 0
