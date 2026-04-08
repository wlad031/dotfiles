from __future__ import annotations

import json
import os
import subprocess
import sys
import time
from pathlib import Path


CACHE_PATH = Path(os.path.expanduser("~/.cache/television/raycast_apps.tsv"))


def parse_desktop_entry(text: str) -> dict[str, str]:
    in_entry = False
    out: dict[str, str] = {}
    for raw in text.splitlines():
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        if line.startswith("[") and line.endswith("]"):
            in_entry = line == "[Desktop Entry]"
            continue
        if not in_entry:
            continue
        if "=" not in line:
            continue
        k, v = line.split("=", 1)
        out[k.strip()] = v.strip()
    return out


def emit(kind: str, label: str, detail: str, payload: str) -> None:
    label = label.replace("\t", " ").replace("\n", " ")
    detail = detail.replace("\t", " ").replace("\n", " ")
    payload = payload.replace("\n", " ")
    print(f"{kind}\t{label}\t{detail}\t{payload}")


def build_apps_cache() -> None:
    CACHE_PATH.parent.mkdir(parents=True, exist_ok=True)

    dirs = [
        Path(os.path.expanduser("~/.local/share/applications")),
        Path("/usr/local/share/applications"),
        Path("/usr/share/applications"),
    ]

    rows: list[tuple[str, str]] = []
    seen: set[str] = set()

    for d in dirs:
        if not d.is_dir():
            continue
        # Most installs keep .desktop files at the top level.
        for p in sorted(d.glob("*.desktop")):
            desktop_id = p.name.removesuffix(".desktop")
            if desktop_id in seen:
                continue
            try:
                entry = parse_desktop_entry(p.read_text(errors="ignore"))
            except OSError:
                continue
            if entry.get("Type") != "Application":
                continue
            if entry.get("NoDisplay") == "true" or entry.get("Hidden") == "true":
                continue
            name = entry.get("Name")
            if not name:
                continue
            seen.add(desktop_id)
            rows.append((desktop_id, name))

    rows.sort(key=lambda r: r[1].casefold())
    tmp = CACHE_PATH.with_suffix(".tmp")
    tmp.write_text("\n".join(f"{did}\t{name}" for did, name in rows) + "\n")
    tmp.replace(CACHE_PATH)


def iter_apps_from_cache() -> list[tuple[str, str]]:
    try:
        text = CACHE_PATH.read_text(errors="ignore")
    except OSError:
        return []
    out: list[tuple[str, str]] = []
    for raw in text.splitlines():
        if not raw.strip():
            continue
        did, name = (raw.split("\t", 1) + [""])[:2]
        if did and name:
            out.append((did, name))
    return out


def maybe_refresh_cache_async(max_age_s: float = 7 * 24 * 3600) -> None:
    try:
        st = CACHE_PATH.stat()
    except OSError:
        return
    if time.time() - st.st_mtime < max_age_s:
        return
    # Fire-and-forget refresh.
    subprocess.Popen([sys.executable, __file__, "--rebuild-cache"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


def main(argv: list[str]) -> int:
    if "--rebuild-cache" in argv:
        build_apps_cache()
        return 0

    # Built-in actions
    emit("action", "Calculator", "qalc", "calc")
    emit("action", "Calc clipboard", "qalc (copy result)", "calc_clipboard")
    emit("action", "Emoji", "search and copy", "emoji")
    emit("action", "Clipboard history", "CopyQ", "copyq")

    # Quick commands (from quick.toml heredoc)
    quick_path = Path(os.path.expanduser("~/.config/television/cable/quick.toml"))
    try:
        text = quick_path.read_text(errors="ignore")
    except OSError:
        text = ""

    in_block = False
    for raw in text.splitlines():
        line = raw.rstrip("\n")
        if "cat <<'EOF'" in line:
            in_block = True
            continue
        if in_block and line.strip() == "EOF":
            in_block = False
            continue
        if not in_block:
            continue

        row = line.strip()
        if not row:
            continue

        if "|" in row:
            label, cmd = (row.split("|", 1) + [""])[:2]
            label = label.strip()
            cmd = cmd.strip()
        else:
            label = row
            cmd = row

        if not cmd:
            continue

        emit("cmd", label, "tmux", cmd)

    # Apps (cached)
    if not CACHE_PATH.exists():
        build_apps_cache()
    else:
        maybe_refresh_cache_async()

    for desktop_id, name in iter_apps_from_cache():
        emit("app", name, f"app  {desktop_id}", desktop_id)

    # Hyprland windows (best-effort)
    try:
        out = subprocess.check_output(["hyprctl", "clients", "-j"], text=True)
        clients = json.loads(out)
    except Exception:
        clients = []

    for c in clients:
        if not c.get("mapped", False):
            continue
        addr = c.get("address")
        if not addr:
            continue
        ws = (c.get("workspace") or {}).get("name", "?")
        klass = c.get("class", "?")
        title = c.get("title", "") or "(untitled)"
        emit("win", title, f"win  ws:{ws}  {klass}", addr)

    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
