#!/usr/bin/env python3

import configparser
import subprocess
import requests
import socket
import argparse
import logging
import logging.handlers
from pathlib import Path

CONFIG_FILE = Path("/etc/disk_alert.ini")

def get_df_usage():
    result = subprocess.run(
        ["df", "--output=source,pcent,target"],
        capture_output=True, text=True, check=True
    )
    lines = result.stdout.strip().splitlines()[1:]
    disks = {}
    for line in lines:
        parts = line.split()
        if len(parts) != 3:
            continue
        device, percent, mountpoint = parts
        disks[device] = (int(percent.strip('%')), mountpoint)
    return disks

def get_zfs_usage():
    try:
        result = subprocess.run(
            ["zpool", "list", "-H", "-o", "name,capacity"],
            capture_output=True, text=True, check=True
        )
    except FileNotFoundError:
        return {}
    pools = {}
    lines = result.stdout.strip().splitlines()
    for line in lines:
        name, percent = line.split()
        pools[name] = (int(percent.strip('%')), f"zpool:{name}")
    return pools

def get_all_usage():
    disks = get_df_usage()
    pools = get_zfs_usage()
    disks.update(pools)
    return disks

def generate_config():
    disks = get_all_usage()
    config = configparser.ConfigParser()
    config["global"] = {
        "webhook_url": "https://shoutrrr.local.vgerasimov.dev/send",
        "log": "yes"
    }
    for disk in disks:
        config[disk] = {
            "thresholds": "80,90,95",
            "emojis": "🔔,⚠️,🚨"
        }
    with CONFIG_FILE.open("w") as f:
        config.write(f)
    print(f"Config generated at {CONFIG_FILE}")

def load_config():
    if not CONFIG_FILE.exists():
        print(f"No config found at {CONFIG_FILE}, run with --generate-config first.")
        exit(1)
    config = configparser.ConfigParser()
    config.read(CONFIG_FILE)
    return config

def send_alert(webhook_url, disk, mountpoint, usage, threshold, emoji):
    host = socket.gethostname()
    message = f"{emoji} Threshold {threshold}% exceeded on {host}: {disk} ({mountpoint}) at {usage}%"
    requests.post(
        webhook_url,
        json={"message": message},
        timeout=5
    )
    logger.info(f"Sent alert: {message}")

def check_disks(config):
    disks = get_all_usage()
    webhook_url = config["global"]["webhook_url"]
    for disk, (usage, mountpoint) in disks.items():
        if disk in config:
            thresholds = [int(x) for x in config[disk]["thresholds"].split(",")]
            emojis = config[disk].get("emojis", "").split(",")
            for idx, threshold in enumerate(sorted(thresholds)):
                if usage >= threshold:
                    emoji = emojis[idx] if idx < len(emojis) else "❗"
                    send_alert(webhook_url, disk, mountpoint, usage, threshold, emoji)
                    break

def setup_logger(enable):
    global logger
    logger = logging.getLogger("disk_alert")
    logger.setLevel(logging.INFO)
    if enable:
        handler = logging.handlers.SysLogHandler(address="/dev/log")
        formatter = logging.Formatter('%(name)s: %(levelname)s %(message)s')
        handler.setFormatter(formatter)
        logger.addHandler(handler)
    else:
        logger.addHandler(logging.NullHandler())

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--generate-config", action="store_true")
    args = parser.parse_args()

    if args.generate_config:
        generate_config()
    else:
        config = load_config()
        log_enabled = config["global"].get("log", "no").lower() == "yes"
        setup_logger(log_enabled)
        check_disks(config)

if __name__ == "__main__":
    main()

