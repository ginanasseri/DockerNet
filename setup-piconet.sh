#!/bin/bash

# Enable IP forwarding
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p

# Set up IPTables rules for NAT
# MASQUERADE traffic from r-nat-net going out to nat-net
iptables -t nat -A POSTROUTING -s 172.16.1.0/24 -o eth0 -j MASQUERADE


iptables -t nat -A POSTROUTING -s 172.16.1.0/24 -p udp --dport 53 -j MASQUERADE
iptables -A FORWARD -p udp --dport 53 -j ACCEPT

# Allow forwarding from r-nat-net to nat-net
iptables -A FORWARD -i r-pico -o pico-nat -j ACCEPT

# Allow forwarding from nat-net to r-nat-net (response traffic)
iptables -A FORWARD -i pico-nat -o r-pico -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

iptables -A FORWARD -p icmp -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -j ACCEPT


# Persist IPTables rules
netfilter-persistent save

# Restart services (uncomment if needed)
# service ssh restart
# service nginx restart
service dnsmasq restart


# Keep the container running
tail -f /dev/null

