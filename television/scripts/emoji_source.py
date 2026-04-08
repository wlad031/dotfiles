from __future__ import annotations

import os
import sys
from pathlib import Path


def main() -> int:
    # speech-dispatcher ships a huge emoji/symbol dictionary we can reuse.
    path = Path("/usr/share/speech-dispatcher/locale/en/emojis.dic")
    try:
        text = path.read_text(errors="ignore")
    except OSError:
        return 0

    in_symbols = False
    for raw in text.splitlines():
        line = raw.strip("\n")
        if not line:
            continue
        if line.startswith("#"):
            continue
        if line == "symbols:" or line.endswith("symbols:"):
            in_symbols = True
            continue
        if not in_symbols:
            continue

        # Format: <char> TAB <name> TAB <category>
        parts = line.split("\t")
        if len(parts) < 2:
            continue
        ch = parts[0].strip()
        name = parts[1].strip()
        cat = parts[2].strip() if len(parts) >= 3 else ""
        if not ch or not name:
            continue
        name = name.replace("\t", " ")
        cat = cat.replace("\t", " ")
        try:
            print(f"emoji\t{ch}\t{name}\t{cat}")
        except BrokenPipeError:
            return 0

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
