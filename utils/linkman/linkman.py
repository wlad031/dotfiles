#!/usr/bin/env python3

import json
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

DEFAULT_CONFIG_FILES = [
    Path("~/.config/linkman/linkman.yaml"),
    Path("~/.config/linkman/linkman.host.yaml"),
]
STATE_FILE = ".link_state"


def log_info(msg):
    print(f"[INFO] {msg}")


def log_warn(msg):
    print(f"[WARN] {msg}")


def detect_yq_flavor():
    try:
        version = subprocess.check_output(["yq", "--version"], text=True).strip()
    except subprocess.CalledProcessError as exc:
        raise RuntimeError("Failed to run yq") from exc
    if "mikefarah" in version or version.startswith("yq version "):
        return "mikefarah"
    if version.startswith("yq "):
        return "python"
    return "unknown"


def merge_configs(config_paths):
    if not shutil.which("yq"):
        raise RuntimeError("Missing required command 'yq'")

    flavor = detect_yq_flavor()
    expr = (
        "reduce .[] as $item ({}; . * $item) "
        "| with_entries(.value |= with_entries(select(.value != null)))"
    )

    if flavor == "mikefarah":
        cmd = ["yq", "-o=json", "eval-all", expr, *config_paths]
    elif flavor == "python":
        cmd = ["yq", "-j", "-s", expr, *config_paths]
    else:
        raise RuntimeError("Unsupported yq implementation")

    try:
        output = subprocess.check_output(cmd, text=True)
    except subprocess.CalledProcessError as exc:
        raise RuntimeError("Failed to merge config files") from exc

    if not output.strip():
        return {}

    data = json.loads(output)
    if not isinstance(data, dict):
        raise RuntimeError("Merged config must be a mapping at top level")
    return data


def parse_config(config_paths):
    data = merge_configs(config_paths)
    config = {}
    sections = set()

    for section, entries in data.items():
        if entries is None:
            continue
        if not isinstance(entries, dict):
            raise RuntimeError(f"Section '{section}' must be a mapping")
        sections.add(section)
        for src, dst in entries.items():
            if dst is None:
                continue
            if not isinstance(dst, str):
                raise RuntimeError(f"Destination for '{section}:{src}' must be a string or null")
            config[f"{section}::{src}"] = dst
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
    file_path = Path(file_path)
    file_path.parent.mkdir(parents=True, exist_ok=True)
    tmp_fd, tmp_path = tempfile.mkstemp(prefix=file_path.name + ".", dir=str(file_path.parent))
    try:
        with os.fdopen(tmp_fd, "w", encoding="utf-8") as f:
            for key, val in config.items():
                f.write(f"{key}={val}\n")
        os.replace(tmp_path, file_path)
    finally:
        try:
            os.unlink(tmp_path)
        except FileNotFoundError:
            pass


def normalize_path(path):
    return str(Path(path).expanduser())


def resolved_path(path):
    return str(Path(path).expanduser().resolve(strict=False))


def same_link_target(dst, src):
    if not os.path.islink(dst):
        return False
    return resolved_path(dst) == resolved_path(src)


def ensure_parent_dir(dst):
    parent = Path(dst).parent
    if str(parent) and str(parent) != ".":
        parent.mkdir(parents=True, exist_ok=True)


def link_config_file(src, dst, dry_run):
    dst = normalize_path(dst)
    src = normalize_path(src)

    if not os.path.exists(src):
        if dry_run:
            print(f"~ [linkman] SKIP {dst} (source missing: {src})")
        else:
            log_warn(f"Skipping: {dst} source missing: {src}")
        return False

    if os.path.exists(dst) and not os.path.islink(dst):
        if dry_run:
            print(f"~ [linkman] SKIP {dst} (exists and not a symlink)")
        else:
            log_warn(f"Skipping: {dst} exists and is not a symlink")
        return False

    if os.path.islink(dst) and same_link_target(dst, src):
        if dry_run:
            print(f"= [linkman] KEEP {dst} -> {src}")
        return True

    if dry_run:
        print(f"+ [linkman] LINK {dst} -> {src}")
        return True

    ensure_parent_dir(dst)
    if os.path.lexists(dst):
        if not os.path.islink(dst):
            log_warn(f"Skipping: {dst} exists and is not a symlink")
            return False
        os.remove(dst)
    os.symlink(src, dst)
    log_info(f"Linked: {dst} -> {src}")
    return True


def apply(config, state, sections, dry_run):
    filtered = {k: v for k, v in config.items() if k.split("::")[0] in sections}
    new_state = state.copy()

    for key, dst in filtered.items():
        section, src = key.split("::", 1)
        dst = normalize_path(dst)
        src = normalize_path(src)

        if not os.path.exists(src):
            if dry_run:
                print(f"~ [{section}] SKIP {dst} (source missing: {src})")
            else:
                log_warn(f"Skipping: {dst} source missing: {src}")
            continue

        if os.path.exists(dst) and not os.path.islink(dst):
            if dry_run:
                print(f"~ [{section}] SKIP {dst} (exists and not a symlink)")
            else:
                log_warn(f"Skipping: {dst} exists and is not a symlink")
            continue

        if os.path.islink(dst) and same_link_target(dst, src):
            if dry_run:
                print(f"= [{section}] KEEP {dst} -> {src}")
            new_state[key] = dst
            continue

        if dry_run:
            print(f"+ [{section}] LINK {dst} -> {src}")
        else:
            ensure_parent_dir(dst)
            if os.path.lexists(dst):
                if not os.path.islink(dst):
                    log_warn(f"Skipping: {dst} exists and is not a symlink")
                    continue
                os.remove(dst)
            os.symlink(src, dst)
            log_info(f"Linked: {dst} -> {src}")
        new_state[key] = dst

    for key, dst in state.items():
        section, src = key.split("::", 1)
        if section not in sections or key in config:
            continue
        dst = normalize_path(dst)
        src = normalize_path(src)
        if os.path.islink(dst) and same_link_target(dst, src):
            if dry_run:
                print(f"- [{section}] UNLINK {dst} -> {src}")
            else:
                os.remove(dst)
                log_info(f"Unlinked: {dst} -> {src}")
                new_state.pop(key, None)
        else:
            if dry_run:
                print(f"~ [{section}] SKIP {dst} (not a matching symlink)")
            else:
                log_warn(f"Skipping cleanup: {dst} not a matching symlink")

    if not dry_run:
        save_state(STATE_FILE, new_state)


def clean(state, sections):
    for key, dst in list(state.items()):
        section, src = key.split("::", 1)
        if section not in sections:
            continue
        dst = normalize_path(dst)
        src = normalize_path(src)
        if os.path.islink(dst) and same_link_target(dst, src):
            os.remove(dst)
            log_info(f"Cleaned: {dst} -> {src}")
            del state[key]
        else:
            log_warn(f"Not a matching symlink: {dst}")
    save_state(STATE_FILE, state)


def main():
    if len(sys.argv) < 2 or sys.argv[1] not in ("apply", "clean", "apply-linkman"):
        print(
            "Usage: linkman.py {apply|clean} [--dry-run] [--config path] [--all|-a|<sections...>]\n"
            "       linkman.py apply-linkman [--dry-run] [--source-root path] [host-folder]"
        )
        sys.exit(1)

    cmd = sys.argv[1]
    args = sys.argv[2:]
    dry_run = False
    config_paths = []
    selected_args = []
    source_root = None

    i = 0
    while i < len(args):
        arg = args[i]
        if arg == "--dry-run":
            dry_run = True
        elif arg == "--config":
            i += 1
            if i >= len(args):
                print("error: --config requires a path")
                sys.exit(1)
            config_paths.append(args[i])
        elif arg == "--source-root":
            i += 1
            if i >= len(args):
                print("error: --source-root requires a path")
                sys.exit(1)
            source_root = args[i]
        else:
            selected_args.append(arg)
        i += 1

    if cmd == "apply-linkman":
        host = selected_args[0] if selected_args else None
        if len(selected_args) > 1:
            print("error: apply-linkman accepts at most one host folder")
            sys.exit(1)

        repo_root = (
            Path(source_root).expanduser().resolve()
            if source_root
            else Path(__file__).resolve().parents[2]
        )
        common_src = repo_root / "linkman" / "common" / "linkman.yaml"
        config_dir = Path("~/.config/linkman").expanduser()
        common_dst = config_dir / "linkman.yaml"

        ok = link_config_file(str(common_src), str(common_dst), dry_run)
        if host:
            host_src = repo_root / "linkman" / "hosts" / host / "linkman.yaml"
            host_dst = config_dir / "linkman.host.yaml"
            if not link_config_file(str(host_src), str(host_dst), dry_run):
                ok = False

        sys.exit(0 if ok else 1)

    if not config_paths:
        config_paths = [str(path.expanduser()) for path in DEFAULT_CONFIG_FILES]

    existing_paths = []
    for path in config_paths:
        if os.path.exists(path):
            existing_paths.append(path)
        else:
            log_warn(f"Missing config: {path}")

    if not existing_paths:
        sys.exit(1)

    config, all_sections = parse_config(existing_paths)
    state = parse_state(STATE_FILE)

    if not selected_args or selected_args[0] in ("--all", "-a"):
        selected_sections = all_sections
    else:
        selected_sections = set(selected_args)

    if cmd == "apply":
        apply(config, state, selected_sections, dry_run)
    elif cmd == "clean":
        clean(state, selected_sections)


if __name__ == "__main__":
    main()
