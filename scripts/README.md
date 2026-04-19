# scripts

## reset-xhci.sh

Resets PCI xHCI controller `0000:0f:00.0` by writing `1` to:

`/sys/bus/pci/devices/0000:0f:00.0/reset`

The script sends desktop notifications via `notify-send`:

- success: `USB controller: xHCI reset done`
- failure: reason in a critical notification

### Why sudo is needed

The `reset` sysfs node is usually root-writable only. For Waybar clicks (non-interactive), configure passwordless sudo only for this exact write path.

Create sudoers entry:

```bash
printf '%s\n' 'vgerasimov ALL=(root) NOPASSWD: /sbin/tee /sys/bus/pci/devices/*/reset' | sudo tee /etc/sudoers.d/90-xhci-reset >/dev/null
sudo chmod 0440 /etc/sudoers.d/90-xhci-reset
sudo visudo -cf /etc/sudoers.d/90-xhci-reset
```

Test non-interactive path:

```bash
printf '1\n' | sudo -n /sbin/tee /sys/bus/pci/devices/0000:0f:00.0/reset >/dev/null && echo OK
```

If the command prints `OK`, Waybar integration should work.
