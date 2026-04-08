from __future__ import annotations

import os
import subprocess
import sys


def _check_output(argv: list[str]) -> str:
    return subprocess.check_output(argv, text=True).strip()


def tmux_target_pane() -> str | None:
    if os.environ.get("TV_TMUX_TARGET_PANE"):
        return os.environ["TV_TMUX_TARGET_PANE"]
    if os.environ.get("TMUX"):
        return _check_output(["tmux", "display-message", "-p", "#{pane_id}"])

    try:
        rows = subprocess.check_output(
            ["tmux", "list-clients", "-F", "#{client_activity} #{client_name}"],
            text=True,
        ).splitlines()
    except Exception:
        return None

    best_activity = None
    best_client = None
    for row in rows:
        try:
            activity_s, client = row.split(" ", 1)
            activity = int(activity_s)
        except Exception:
            continue
        if best_activity is None or activity > best_activity:
            best_activity = activity
            best_client = client
    if not best_client:
        return None
    return _check_output(["tmux", "display-message", "-p", "-t", best_client, "#{pane_id}"])


def tmux_pane_cwd(pane: str) -> str:
    return _check_output(["tmux", "display-message", "-p", "-t", pane, "#{pane_current_path}"])


def run_in_tmux(where: str, cmd: str) -> None:
    pane = tmux_target_pane()
    if not pane:
        subprocess.Popen(["zsh", "-lc", cmd])
        return

    cwd = tmux_pane_cwd(pane)
    # Keep the pane alive after the command exits.
    shell_cmd = 'eval "$1"; exec zsh -l'

    if where == "window":
        subprocess.check_call(
            [
                "tmux",
                "new-window",
                "-c",
                cwd,
                "zsh",
                "-lc",
                shell_cmd,
                "zsh",
                cmd,
            ]
        )
        return

    split_flag = "-h" if where == "hsplit" else "-v"
    subprocess.check_call(
        [
            "tmux",
            "split-window",
            split_flag,
            "-t",
            pane,
            "-c",
            cwd,
            "zsh",
            "-lc",
            shell_cmd,
            "zsh",
            cmd,
        ]
    )


def calc_clipboard() -> None:
    expr = subprocess.check_output(["wl-paste", "-n"], text=True).strip()
    if not expr:
        return
    res = subprocess.check_output(["qalc", "-t", "-e", expr], text=True).strip()
    subprocess.run(["wl-copy"], input=res, text=True, check=False)
    subprocess.Popen(["notify-send", "Calc", f"{expr} = {res}"])


def main(argv: list[str]) -> int:
    if len(argv) < 3:
        raise SystemExit("usage: raycast_dispatch.py <action> <entry>")

    action = argv[1]
    entry = argv[2]
    parts = entry.split("\t", 3)
    parts += [""] * (4 - len(parts))
    kind, _label, _detail, payload = parts[:4]

    if kind == "app":
        # payload: desktop id
        subprocess.Popen(
            ["setsid", "-f", "gtk-launch", payload],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        return 0

    if kind == "win":
        subprocess.check_call(["hyprctl", "dispatch", "focuswindow", f"address:{payload}"])
        return 0

    if kind == "cmd":
        where = "window" if action == "default" else action
        if where not in {"hsplit", "vsplit", "window"}:
            where = "window"
        run_in_tmux(where, payload)
        return 0

    if kind == "action":
        if payload == "calc":
            os.execvp("qalc", ["qalc"])
        if payload == "calc_clipboard":
            calc_clipboard()
        if payload == "emoji":
            os.execvp("tv", ["tv", "emoji"])
        if payload == "copyq":
            os.execvp("tv", ["tv", "copyq"])
        return 0

    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
