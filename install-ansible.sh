#!/usr/bin/env bash

set -e

source "$(dirname "${BASH_SOURCE[0]}")/scripts/common.sh"

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

