#!/usr/bin/env bash

set -e

f="$HOME/.cache/bash/logging.sh"; [ -f "$f" ] || (mkdir -p "${f%/*}" && wget -qO "$f" https://gitea.local.vgerasimov.dev/wlad031/dotfiles/raw/branch/master/bash/lib/logging.sh); source "$f"

if ! command -v uv &> /dev/null; then
  log_error "uv not found"
  exit 1
fi

if command -v ansible &> /dev/null; then
  log_info "ansible is already installed"
  exit 0
fi

log_info "ansible not found. Installing with uv..."
uv tool install ansible

