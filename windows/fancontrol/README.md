# FanControl configuration

This folder stores a backup/reference copy of the Windows FanControl config from:

```text
C:\Program Files\FanControl\Configurations\userConfig.json
```

## Files

- `userConfig.json` — copied FanControl configuration.

## Instructions for LLM agents

When asked to inspect or modify FanControl behavior on this PC:

1. Treat `userConfig.json` in this folder as the tracked/reference copy.
2. The live Windows config is:

   ```text
   /mnt/c/Program Files/FanControl/Configurations/userConfig.json
   ```

3. Before changing the live config, make a timestamped backup, for example:

   ```bash
   cp "/mnt/c/Program Files/FanControl/Configurations/userConfig.json" \
      "$HOME/dotfiles/windows/fancontrol/userConfig.backup-$(date +%Y%m%d-%H%M%S).json"
   ```

4. If editing the live config, stop FanControl first and restart it after writing:

   ```powershell
   Stop-ScheduledTask -TaskName FanControl
   Stop-Process -Name FanControl -Force -ErrorAction SilentlyContinue
   Start-ScheduledTask -TaskName FanControl
   ```

   These commands may require elevated Windows PowerShell / UAC.

5. After a successful live change, copy the live config back into this folder:

   ```bash
   cp "/mnt/c/Program Files/FanControl/Configurations/userConfig.json" \
      "$HOME/dotfiles/windows/fancontrol/userConfig.json"
   ```

6. Be careful with fan curves. FanControl curves directly affect thermals and noise. Ask the user before making aggressive cooling/noise trade-offs.

## Current context

This config was copied after setting quieter emergency-ramp curves:

- `CPU Ultra Quiet Curve` uses CPU Tctl/Tdie: `/amdcpu/0/temperature/2`
- `Pump Ultra Quiet Curve` uses CPU Tctl/Tdie: `/amdcpu/0/temperature/2`
- `GPU Hotspot Ultra Quiet Curve` uses GPU hotspot: `/gpu-amd/5/temperature/7`

Sensor logs, task backups, and prior FanControl config backups may exist on Windows at:

```text
C:\Users\geras\SensorLogs
```
