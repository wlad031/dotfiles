set -eu

SHIM_IF="macvlan-shim"
PIHOLE_IP="10.10.10.50"

ip route del "${PIHOLE_IP}/32" dev "$SHIM_IF" 2>/dev/null || true
ip link del "$SHIM_IF" 2>/dev/null || true
