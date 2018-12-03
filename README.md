# Securing Linux with a Faster and Scalable Iptables

This repository contains the datasets and the scripts used for the evaluation section of the paper "Securing Linux with a Faster and Scalable Iptables", which has been submitted to the SIGCOMM Computer Communication Review.



## Test environment

#### Setup

Our testbed includes a first server used as DUT running the firewall under test and a second used as packet generator (and possibly receiver).
The DUT encompasses an Intel Xeon Gold 5120 14-cores CPU @2.20GHz (hyper-threading disabled) with support for Intel's Data Direct I/O (DDIO), 19.25 MB of L3 cache and two 32GB RAM modules.
The packet generator is equipped with an Intel Xeon CPU E3-1245 v5 4-cores CPU @3.50GHz (8 cores with hyper-threading), 8MB of L3 cache and two 16GB RAM modules.

Both servers run <u>Ubuntu 18.04.1 LTS</u>, with the packet generator using kernel 4.15.0-36 and the DUT running kernel 4.19.0.
Each server has a dual-port Intel XL710 40Gbps NIC, each port directly connected to the corresponding one of the other server.

To correctly replicate the results described in the paper, you should use a similar setup since the scripts have been created with that setup in mind.



#### Testing tools

##### Pktgen-DPDK

For UDP tests, we used **pktgen-dpdk** to generate traffic. We used a customized version, which supports the possibility to generate packets randomly distributed in a given range.

Our version can be download at [this](https://github.com/sebymiano/pktgen-dpdk) URL and installed with the following commands:

```bash
# Dependency: DPDK v18.08 installed on the system
# Install Pktgen-DPDK
$ mkdir -p $HOME/dev
$ cd $HOME/dev && git clone https://github.com/sebymiano/pktgen-dpdk
$ cd pktgen-dpdk && make -j4

```

 Note: it is important to install pktgen-dpdk under the directory `$HOME/dev` since this is the default path used in the test scripts.

