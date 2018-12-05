#!/bin/bash

nft add table ip filter
nft add chain filter $CHAIN \{ type filter hook forward priority 0\; policy accept\; \}
nft add rule ip filter $CHAIN counter accept
