#!/bin/bash
# Firewall rules for web-01 / web-02
# - Allow SSH (22) from anywhere
# - Allow HTTP (80) ONLY from the load balancer (lb-01)
# - Deny everything else inbound

LB_IP="172.25.0.10"   # lb-01's internal Docker network IP

iptables -F
iptables -X

iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -s "$LB_IP" --dport 80 -j ACCEPT

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

echo "Firewall rules applied. Current rules:"
iptables -L -v -n