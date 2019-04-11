#!/bin/bash

set -x

sudo iptables -F -t nat
sudo iptables -F -t filter
sudo iptables -F -t mangle
sudo iptables -F -t raw
sudo iptables -F -t security

sudo rmmod iptable_nat
sudo rmmod ipt_MASQUERADE
sudo rmmod openvswitch
sudo rmmod nf_nat_ipv6
sudo rmmod nf_nat_ipv4
sudo rmmod nf_nat
sudo rmmod nf_conncount
sudo rmmod xt_conntrack
sudo rmmod nf_conntrack_netlink
sudo rmmod nf_conntrack
sudo rmmod iptable_filter
sudo rmmod ip6table_filter
sudo rmmod ebtable_filter
sudo rmmod iptable_mangle
sudo rmmod iptable_security
sudo rmmod iptable_raw
sudo rmmod ip_tables
sudo rmmod nf_defrag_ipv6
sudo rmmod nf_defrag_ipv4
sudo rmmod ebtables
sudo rmmod xt_tcpudp
sudo rmmod xt_CHECKSUM
sudo rmmod ip6_tables
sudo rmmod ipt_REJECT
sudo rmmod x_tables
sudo rmmod ip_set_hash_ipport
sudo rmmod ip_set
sudo rmmod nf_reject_ipv4
sudo rmmod nf_tables
sudo rmmod bpfilter
