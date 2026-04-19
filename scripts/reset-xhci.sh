#!/usr/bin/env bash
set -euo pipefail

DEV="/sys/bus/pci/devices/0000:0f:00.0/reset"

if [ ! -e "$DEV" ]; then
  notify-send "USB reset failed" "Device not found: $DEV" --urgency=critical
  exit 1
fi

if [ -w "$DEV" ]; then
  printf '1' > "$DEV"
  notify-send "USB controller" "xHCI reset done"
  exit 0
fi

if printf '1\n' | sudo -n /sbin/tee "$DEV" >/dev/null 2>&1; then
  notify-send "USB controller" "xHCI reset done"
  exit 0
fi

notify-send "USB reset failed" "No write permission. Configure passwordless sudo for this script." --urgency=critical
exit 1
