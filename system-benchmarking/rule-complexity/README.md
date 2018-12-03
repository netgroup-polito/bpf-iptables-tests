## Performance dependency on the number of matching fieds

Since the `bpf-iptables` modular pipeline requires a separate eBPF program (hence an additional processing penalty) for each matching field, this test evaluates the throughput of `bpf-iptables` when augmenting the number of matching fields in the deployed rules in order to characterize the (possible) performance degradation when operating on a growing number of protocol fields.

#### Rule-sets

The rule-sets used for this tests can be found in the [rulsets](./rulesets) folder.

#### Test description

The packet generator is configured to generate traffic uniformly distributed among all the rules so that all packets will uniformly match the rules and no packet will match the default action of the chain, in other words, the number of flows generated is equal to the number of rules under consideration.

##### Setup

The packet generator and the DUT should be connected each other through an XDP-compatible NIC. In particular, the first interface of the generator is connected to the first interface of the DUT and the same for the second interface (which are configured accordingly in the following scripts).

In addition, both machine should be able to communicate at IP level through an additional interface. The IP addresses of those interface should be configured in the following scripts.

##### Scripts

This folder contains a single script [run-tests](./run-tests.sh) that is used to execute the multi-core and single-core tests.

Both scripts can be configurable by passing the correct parameters through the command line, for example:

```bash
$ ./run-tests-multi.sh -h
run-tests.sh [-h] [-r #runs] [-o output_file] [-i|-n]
Run tests of pcn-iptables for the FORWARD chain with a different number of matching fields (1000 rules)

where:
    -h  show this help text
    -r  number of runs for the test
    -o  path to file where the results are placed
    -i  use iptables
    -n  use nftables
```

In addition, you should modify the script with the correct IP addresses and folders used in your environment. The parameters that should be set are the following:

```bash
# Remote configurations (DUT)
REMOTE_DUT=1.1.1.1 (IP Address of the DUT)
REMOTE_FOLDER="~/bpf-iptables-tests/system-benchmarking/ruleset-size"
DST_MAC_IF0="3cfd:feaf:ec30" (MAC of the receiver interface of the DUT)
DST_MAC_IF1="3cfd:feaf:ec31" (MAC of the sender interface of the DUT)
INGRESS_IFACE_NAME="enp101s0f0" (Name of the receiver interface of the DUT)

# Local configurations (Pkt generator)
PKTGEN_FOLDER="$HOME/dev/pktgen-dpdk"
LOCAL_NAME=cube1 (Name of the user in the pkt generator machine)
LOCAL_DUT=IPADDRESS (IP address of the pkt generator machine)
```

For example, to execute a single run of the multi-core test using bpf-iptables you should execute the following command:

```bash
$ ./run-tests.sh -r 1 -o bpf-iptables-results
```

