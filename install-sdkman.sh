#!/usr/bin/env bash

set -e

. "./scripts/common.sh"

if command -v sdk &> /dev/null; then
  log_info "sdkman is already installed"
  exit 0
fi

log_info "sdkman not found. Installing..."
INSTALL_SCRIPT_URL="https://get.sdkman.io"
if command -v curl &> /dev/null; then
  curl -LsSf "$INSTALL_SCRIPT_URL" | sh
elif command -v wget &> /dev/null; then
  wget -qO- "$INSTALL_SCRIPT_URL" | sh
else
  log_error "Neither curl nor wget is installed. Cannot download installer"
  exit 1
fi
