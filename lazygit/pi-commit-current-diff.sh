#!/usr/bin/env bash
set -euo pipefail

root="$(git rev-parse --show-toplevel)"
cd "$root"

if git diff --cached --quiet --exit-code; then
  echo "No staged changes to commit. Stage the files you want included, then run this again."
  exit 1
fi

tmp_prompt="$(mktemp)"
tmp_msg="$(mktemp)"
cleanup() {
  rm -f "$tmp_prompt" "$tmp_msg"
}
trap cleanup EXIT

{
  cat <<'PROMPT'
Analyze the staged git diff below and generate a high-quality commit message.

Output ONLY the commit message text:
- No markdown fences, quotes, commentary, or prefixes.
- Use imperative mood.
- Prefer Conventional Commit style when an obvious type/scope fits.
- Keep the subject line under 72 characters.
- Add a blank line plus wrapped body only if it adds useful context.
PROMPT
  printf '\nStaged files:\n'
  git diff --cached --name-status
  printf '\nStaged diffstat:\n'
  git diff --cached --stat
  printf '\nStaged diff:\n'
  git diff --cached --no-ext-diff --unified=80
} > "$tmp_prompt"

echo "Generating commit message with pi..."
pi --no-session --name "Generate commit message" --print < "$tmp_prompt" > "$tmp_msg"

# Remove common accidental wrappers while preserving intentional multi-line bodies.
python3 - "$tmp_msg" <<'PY'
import pathlib, re, sys
path = pathlib.Path(sys.argv[1])
msg = path.read_text().replace('\r\n', '\n').strip()
msg = re.sub(r'^```(?:text|gitcommit|commit)?\s*\n', '', msg, flags=re.I)
msg = re.sub(r'\n```\s*$', '', msg)
path.write_text(msg.strip() + '\n')
PY

if [[ ! -s "$tmp_msg" ]]; then
  echo "pi returned an empty commit message."
  exit 1
fi

echo
echo "Commit message:"
sed 's/^/  /' "$tmp_msg"
echo

git commit -F "$tmp_msg"
