#!/bin/sh

sudo ifconfig enp101s0f0 192.168.0.254/24 up
sudo ifconfig enp101s0f1 192.168.1.254/24 up

sudo ifconfig enp101s0f0 up
sudo ifconfig enp101s0f1 up

sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

while true; do
	sudo arp -s 192.168.0.1 3c:fd:fe:af:ec:48
	sudo arp -s 192.168.0.2 3c:fd:fe:af:ec:48
	sudo arp -s 192.168.0.3 3c:fd:fe:af:ec:48
	sudo arp -s 192.168.0.4 3c:fd:fe:af:ec:48
	sudo arp -s 192.168.0.5 3c:fd:fe:af:ec:48
	sudo arp -s 192.168.0.6 3c:fd:fe:af:ec:48
	sudo arp -s 192.168.0.7 3c:fd:fe:af:ec:48
	sudo arp -s 192.168.0.8 3c:fd:fe:af:ec:48
	sudo arp -s 192.168.0.9 3c:fd:fe:af:ec:48
	sudo arp -s 192.168.0.10 3c:fd:fe:af:ec:48
	sudo arp -s 192.168.0.11 3c:fd:fe:af:ec:48

	sudo arp -s 192.168.1.1 3c:fd:fe:af:ec:49
	sudo arp -s 192.168.1.2 3c:fd:fe:af:ec:49
	sudo arp -s 192.168.1.3 3c:fd:fe:af:ec:49
	sudo arp -s 192.168.1.4 3c:fd:fe:af:ec:49
	sudo arp -s 192.168.1.5 3c:fd:fe:af:ec:49
	sudo arp -s 192.168.1.6 3c:fd:fe:af:ec:49
	sudo arp -s 192.168.1.7 3c:fd:fe:af:ec:49
	sudo arp -s 192.168.1.8 3c:fd:fe:af:ec:49
	sudo arp -s 192.168.1.9 3c:fd:fe:af:ec:49
	sudo arp -s 192.168.1.10 3c:fd:fe:af:ec:49
	sudo arp -s 192.168.1.11 3c:fd:fe:af:ec:49

	sleep 10
done