#!/bin/bash

# Enable IP forwarding
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p

# Set up IPTables rules for NAT
iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o eth2 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.10.1.0/24 -o eth2 -j MASQUERADE


# Allow forwarding from r-h1-net to r-nat-net
iptables -A FORWARD -i r-h1 -o r-pico -j ACCEPT

# Allow forwarding from r-h2-net to r-nat-net
iptables -A FORWARD -i r-h2 -o r-pico -j ACCEPT

# Allow established and related connections
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

iptables -A FORWARD -p icmp -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -j ACCEPT

service dnsmasq restart

# Persist IPTables rules
netfilter-persistent save

