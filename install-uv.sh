#!/usr/bin/env bash

set -e

# TODO: Use shortened version of a url
f="$HOME/.cache/bash/logging.sh"; [ -f "$f" ] || (mkdir -p "${f%/*}" && wget -qO "$f" https://gitea.local.vgerasimov.dev/wlad031/dotfiles/raw/branch/master/bash/lib/logging.sh); source "$f"

if command -v uv &> /dev/null; then
  log_info "uv is already installed"
  exit 0
fi

log_info "uv not found. Installing..."
INSTALL_SCRIPT_URL="https://astral.sh/uv/install.sh"
if command -v curl &> /dev/null; then
  curl -LsSf "$INSTALL_SCRIPT_URL" | sh
elif command -v wget &> /dev/null; then
  wget -qO- "$INSTALL_SCRIPT_URL" | sh
else
  log_error "Neither curl nor wget is installed. Cannot download installer"
  exit 1
fi

