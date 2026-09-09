#!/usr/bin/env bash

set -e

x="bash/lib/logging.sh"; f="$HOME/dotfiles/$x"; [ -f $f ] || f="$HOME/.cache/dotfiles/$x" && [ -f $f ] || (mkdir -p ${f%/*} && wget -qO $f "https://raw.githubusercontent.com/wlad031/dotfiles/refs/heads/master/$x"); source $f

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

