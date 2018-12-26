# DDoS Mitigation Performance

This tests evaluates the performance of the system under DDoS attack, which represents an optimization provided by `bpf-iptables` thanks to the `HORUS` analysis (described in the paper).

## Rule-sets

The rule-sets used for this tests can be found in the [rulsets](./rulesets) folder.
We used a fixed set of rules (i.e., 1000) matching on IP source, protocol and L4 source port, `DROP` action.
Two additional rules involve the connection tracking to guarantee the reachability of internal servers; (*i*) *accepts* all the `ESTABLISHED` connections and (*ii*) *accepts* all the `NEW` connection with destination L4 port 80.

## Test description

The packet generator sends 64Bytes UDP packets towards the server with the same set of source IP addresses and L4 ports configured in the set of blacklisting rules.
DDoS traffic is sent on a first port connected to the DUT, while a `weighttp` client sends traffic on a second port, simulating a legitimate traffic towards a `nginx` server running in the DUT.
`Weighttp` generates 1M HTTP requests using 1000 concurrent clients; we report the number of successfully completed requests/s, with a timeout of 5 seconds, varying the rate of DDoS traffic.

### Setup

The packet generator and the DUT should be connected each other through a XDP-compatible NIC. 
The first interface of the generator is connected to the first interface of the DUT and is attached to DPDK, so that `pktgen-dpdk` can be used to generate the DDoS traffic.
The second interface of the generator is directly attached to the second interface of the DUT and it is used to generate the legitimate traffic (we suggest to use a separate machine to generate the legitimate traffic in order to avoid interference with the malicious traffic generator)

In addition, both machine should be able to communicate at IP level through an additional interface. The IP addresses of those interface should be configured in the following scripts.

The test requires an `nginx` server running on the remote DUT.
Moreover, you need to create a file named `static_file` and place it under the default web server folder. For the tests described in our paper we used a 100MB file generated with this command.
```bash
$ dd if=/dev/zero of=static_file count=1024 bs=102400
```

On the generator machine, it is necessary to install `weighttp`, which can be downloaded at [this](https://github.com/lighttpd/weighttp.git) url.
Follow the instructions provided to install the tool.

To correctly replicate the results you need to increase the limit of file descriptors opened by a single process.
To do this you can use the `sysctl.conf.generator` and the `sysctl.conf.dut` file available under this folder.
To apply the configuration type:
```bash
$ sudo sysctl -p sysctl.conf.generator
```
on the generator and 
```bash
$ sudo sysctl -p sysctl.conf.dut
```
on the DUT.

### Scripts

This folder contains a single script [run-tests](./run-tests.sh) that is used to execute the test, which can be configured by passing the correct parameters through the command line, for example:

```bash
$ ./run-tests.sh -h
run-tests.sh [-h] [-r \#runs] [-o output_file] [-i|-n|-s|-d]
Run tests of pcn-iptables for the INPUT chain with a different number of rules

where:
    -h  show this help text
    -r  number of runs for the test
    -o  path to file where the results are placed
    -i  use iptables
    -n  use nftables
    -s  use ipset
    -d  use nft_set
```

In addition, you should modify the script with the correct IP addresses and folders used in your environment. The parameters that should be set are the following:

```bash
# Remote configurations (DUT)
REMOTE_DUT=1.1.1.1 (IP Address of the DUT)
REMOTE_FOLDER="~/bpf-iptables-tests/realistic-scenarios/ddos-mitigator"
DST_MAC_IF0="3cfd:feaf:ec30" (MAC of the receiver interface of the DUT)
DST_MAC_IF1="3cfd:feaf:ec31"
INGRESS_REMOTE_IFACE_NAME="enp101s0f0" (Name of the receiver interface of the DUT)
EGRESS_REMOTE_IFACE_NAME="enp101s0f1"

# Local configurations (Pkt generator)
PKTGEN_FOLDER="$HOME/dev/pktgen-dpdk"
INGRESS_LOCAL_IFACE_NAME="enp1s0f0"
EGRESS_LOCAL_IFACE_NAME="enp1s0f1"
LOCAL_NAME=cube1 (Name of the user in the pkt generator machine)
LOCAL_DUT=IPADDRESS (IP address of the pkt generator machine)
```

For example, to execute a single run of the multi-core test using `bpf-iptables` you should execute the following command:

```bash
$ ./run-tests.sh -r 1 -o bpf-iptables-results
```

