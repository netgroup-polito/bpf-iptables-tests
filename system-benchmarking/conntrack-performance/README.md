# Connection tracking performance

This test evaluates the performance of the connection tracking module of `bpf-iptables`, which is required to enable stateful filtering.
The test is based on TCP traffic in order to stress the rather complex state machine of the TCP protocol; it generates a high number of *new* connections per second, taking the number of successfully completed sessions as performance indicator.

## Rule-sets

The rule-sets used for this tests can be found in the [rulsets](./rulesets) folder.
It is composed of three rules loaded in the `INPUT` chain so that only packets directed to a local application will be processed by the firewall.
The first rule *accepts* all packets belonging to an `ESTABLISHED` session, the second rule *accepts* all the `NEW` packets coming from the packet generator and with the TCP destination port equal to 80 and finally, the last rule *drops* all the other packets coming from the packet generator.

## Test description

In this test `weighttp` generates 1M HTTP requests towards the DUT, using an increasing number of concurrent clients to stress the connection tracking module.
At each request, a file of 100 byte is returned by the `nginx` web server running in the DUT.
Once the request is completed, the current connection is closed and a new connection is created.
This required to increase the limit of `1024` open file descriptors per process imposed by Linux in order to allow the sender to generate a larger number of new requests per second and to enable the *net.ipv4.tcp_tw_reuse* flag to reuse sessions in `TIME_WAIT` state in both sender and receiver machines.

### Setup

The packet generator and the DUT should be connected each other through a XDP-compatible NIC. 
The first interface of the generator is connected to the first interface of the DUT (which are configured accordingly in the following scripts).

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

This folder contains a single script [run-tests](./run-tests_weighttp.sh) that is used to execute the test, which can be configured by passing the correct parameters through the command line, for example:

```bash
$ ./run-tests_weighttp.sh -h
run-tests_weighttp.sh [-h] [-r #runs] [-o output_file] [-d duration][-i|-n]

where:
    -h  show this help text
    -r  number of runs for the test
    -o  path to file where the results are placed
    -d  duration of the test, e.g. 2s, 2m, 2h
    -i  use iptables
    -n  use nftables
```

In addition, you should modify the script with the correct IP addresses and folders used in your environment. The parameters that should be set are the following:

```bash
# Remote configurations (DUT)
REMOTE_DUT=1.1.1.1 (IP Address of the DUT)
REMOTE_FOLDER="~/bpf-iptables-tests/system-benchmarking/conntrack-performance"
INGRESS_REMOTE_IFACE_NAME="3cfd:feaf:ec30" (MAC of the receiver interface of the DUT)

# Local configurations (Pkt generator)
INGRESS_LOCAL_IFACE_NAME="enp1s0f0"
LOCAL_NAME=cube1 (Name of the user in the pkt generator machine)
LOCAL_DUT=IPADDRESS (IP address of the pkt generator machine)
```

For example, to execute a single run of the multi-core test using bpf-iptables you should execute the following command:

```bash
$ ./run-tests_weighttp.sh -r 1 -o bpf-iptables-results
```

