#!/usr/bin/env bash
set -e

if ! command -v brew &> /dev/null; then
  echo "brew not found. Installing..."

  INSTALL_SCRIPT_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

  if command -v curl &> /dev/null; then
    curl -LsSf "$INSTALL_SCRIPT_URL" | sh
  elif command -v wget &> /dev/null; then
    wget -qO- "$INSTALL_SCRIPT_URL" | sh
  else
    echo "Neither curl nor wget is installed. Cannot download installer"
    exit 1
  fi
else
  echo "brew is already installed"
fi

