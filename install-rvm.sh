#!/usr/bin/env bash

set -e

. "./scripts/common.sh"

log_info "rvm installation script"
log_info "https://rvm.io/rvm/install"

if command -v rvm &> /dev/null; then
  log_info "rvm is already installed"
  exit 0
fi

log_info "Installing GPG keys..."
gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

log_info "rvm not found. Installing..."
INSTALL_SCRIPT_URL="https://get.rvm.io"
if command -v curl &> /dev/null; then
  curl -LsSf "$INSTALL_SCRIPT_URL" | sh
elif command -v wget &> /dev/null; then
  wget -qO- "$INSTALL_SCRIPT_URL" | sh
else
  log_error "Neither curl nor wget is installed. Cannot download installer"
  exit 1
fi

