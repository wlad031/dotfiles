from __future__ import annotations

import re
import subprocess
import sys


SEP = "\n<<<TV_COPYQ_SEP>>>\n"


def _check_output(argv: list[str]) -> str:
    return subprocess.check_output(argv, text=True, errors="ignore")


def summarize(text: str, max_len: int = 140) -> str:
    s = text.replace("\r", "\n").strip("\n")
    if not s:
        return "(empty)"
    # Use the first non-empty line for display.
    for line in s.split("\n"):
        line = line.strip()
        if line:
            s = line
            break
    s = re.sub(r"\s+", " ", s).strip()
    if len(s) > max_len:
        s = s[: max_len - 1] + "…"
    return s


def main(argv: list[str]) -> int:
    try:
        count_s = _check_output(["copyq", "count"]).strip()
        count = int(count_s) if count_s else 0
    except Exception:
        return 0

    if count <= 0:
        return 0

    # Keep it snappy; still plenty for history.
    limit = min(count, 200)
    indices = [str(i) for i in range(limit)]

    try:
        raw = _check_output(["copyq", "separator", SEP, "read", *indices])
    except Exception:
        return 0

    parts = raw.split(SEP)
    # If copyq returned fewer items than requested, trim.
    parts = parts[:limit]

    for i, item in enumerate(parts):
        # Columns: row, summary
        try:
            print(f"{i}\t{summarize(item)}")
        except BrokenPipeError:
            return 0

    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main(sys.argv))
    except BrokenPipeError:
        raise SystemExit(0)
