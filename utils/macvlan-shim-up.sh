#!/bin/sh
set -eu

PARENT_IF="enp6s0"
SHIM_IF="macvlan-shim"
SHIM_IP="10.10.10.99/24"
PIHOLE_IP="10.10.10.50"

ip link show "$SHIM_IF" >/dev/null 2>&1 || ip link add "$SHIM_IF" link "$PARENT_IF" type macvlan mode bridge

ip addr show dev "$SHIM_IF" | grep -q " ${SHIM_IP%/*}/" || ip addr add "$SHIM_IP" dev "$SHIM_IF"

ip link set "$SHIM_IF" up

ip route replace "${PIHOLE_IP}/32" dev "$SHIM_IF"

sysctl -w net.ipv4.ip_forward=1 >/dev/null

iptables -C FORWARD -i docker0 -o "$SHIM_IF" -j ACCEPT 2>/dev/null || iptables -I FORWARD -i docker0 -o "$SHIM_IF" -j ACCEPT
iptables -C FORWARD -i "$SHIM_IF" -o docker0 -j ACCEPT 2>/dev/null || iptables -I FORWARD -i "$SHIM_IF" -o docker0 -j ACCEPT
