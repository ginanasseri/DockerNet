#!/bin/bash

# Enable IP forwarding
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p

# Set up IPTables rules for NAT
iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o eth2 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.10.1.0/24 -o eth2 -j MASQUERADE


# Allow forwarding from router-host connections to router-gateway 
iptables -A FORWARD -i router-host1 -o router-gateway -j ACCEPT
iptables -A FORWARD -i router-host2 -o router-gateway -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

iptables -A FORWARD -p icmp -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -j ACCEPT

service dnsmasq restart

netfilter-persistent save

# set default route to router-gateway connection
ip route replace default via 172.16.1.3

