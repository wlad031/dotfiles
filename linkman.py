#!/usr/bin/env python

import os
import sys
from pathlib import Path

CONFIG_FILE = "config.ini"
STATE_FILE = ".link_state"


def log_info(msg):
    print(f"[INFO] {msg}")


def log_warn(msg):
    print(f"[WARN] {msg}")


def parse_config(file_path):
    config = {}
    sections = set()
    current_section = None

    with open(file_path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            if line.startswith("[") and line.endswith("]"):
                current_section = line[1:-1].strip()
                sections.add(current_section)
                continue
            if current_section is None:
                continue
            if "=" in line:
                src, dst = map(str.strip, line.split("=", 1))
                config[f"{current_section}::{src}"] = dst
    return config, sections


def parse_state(file_path):
    state = {}
    if not os.path.exists(file_path):
        return state
    with open(file_path, "r", encoding="utf-8") as f:
        for line in f:
            if "=" in line:
                key, val = map(str.strip, line.strip().split("=", 1))
                state[key] = val
    return state


def save_state(file_path, config):
    with open(file_path, "w", encoding="utf-8") as f:
        for key, val in config.items():
            f.write(f"{key}={val}\n")


def apply(config, state, sections, dry_run):
    filtered = {k: v for k, v in config.items() if k.split("::")[0] in sections}

    for key, dst in filtered.items():
        section, src = key.split("::", 1)
        dst = os.path.expanduser(dst)
        src = os.path.expanduser(src)

        if os.path.exists(dst) and not os.path.islink(dst):
            if dry_run:
                print(f"~ [{section}] SKIP {dst} (exists and not a symlink)")
            else:
                log_warn(f"Skipping: {dst} exists and is not a symlink")
            continue

        if dry_run:
            print(f"+ [{section}] LINK {dst} -> {src}")
        else:
            os.makedirs(os.path.dirname(dst), exist_ok=True)
            if os.path.lexists(dst):
                os.remove(dst)
            os.symlink(src, dst)
            log_info(f"Linked: {dst} -> {src}")

    for key, dst in state.items():
        section, src = key.split("::", 1)
        if section not in sections or key in config:
            continue
        dst = os.path.expanduser(dst)
        src = os.path.expanduser(src) # TODO: I can make it configurable, I think
        if os.path.islink(dst) and os.readlink(dst) == src:
            if dry_run:
                print(f"- [{section}] UNLINK {dst} -> {src}")
            else:
                os.remove(dst)
                log_info(f"Unlinked: {dst} -> {src}")
        else:
            if dry_run:
                print(f"- [{section}] REMOVE {dst}")
                print(f"+ [{section}] LINK {dst} -> {src}")
            else:
                os.remove(dst)
                log_info("Removed: " + dst)
                os.symlink(src, dst)
                log_info(f"Linked: {dst} -> {src}")


def clean(state, sections):
    for key, dst in list(state.items()):
        section, src = key.split("::", 1)
        if section not in sections:
            continue
        dst = os.path.expanduser(dst)
        src = os.path.expanduser(src)
        if os.path.islink(dst) and os.readlink(dst) == src:
            os.remove(dst)
            log_info(f"Cleaned: {dst} -> {src}")
        else:
            log_warn(f"Not a symlink or changed: {dst}")
        del state[key]
    save_state(STATE_FILE, state)


def main():
    if len(sys.argv) < 2 or sys.argv[1] not in ("apply", "clean"):
        print("Usage: linkman.py {apply|clean} [--dry-run] [--all|-a|<sections...>]")
        sys.exit(1)

    cmd = sys.argv[1]
    args = sys.argv[2:]
    dry_run = "--dry-run" in args
    args = [a for a in args if a != "--dry-run"]

    config, all_sections = parse_config(CONFIG_FILE)
    state = parse_state(STATE_FILE)

    if not args or args[0] in ("--all", "-a"):
        selected_sections = all_sections
    else:
        selected_sections = set(args)

    if cmd == "apply":
        apply(config, state, selected_sections, dry_run)
        if not dry_run:
            save_state(STATE_FILE, config)
    elif cmd == "clean":
        clean(state, selected_sections)


main()
