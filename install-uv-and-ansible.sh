#!/usr/bin/env bash
set -e

if ! command -v uv &> /dev/null; then
  echo "uv not found. Installing..."

  INSTALL_SCRIPT_URL="https://astral.sh/uv/install.sh"

  if command -v curl &> /dev/null; then
    curl -LsSf "$INSTALL_SCRIPT_URL" | sh
  elif command -v wget &> /dev/null; then
    wget -qO- "$INSTALL_SCRIPT_URL" | sh
  else
    echo "Neither curl nor wget is installed. Cannot download uv installer."
    exit 1
  fi
else
  echo "uv is already installed"
fi

if ! command -v ansible &> /dev/null; then
  echo "ansible not found. Installing with uv..."
  uv tool install ansible
else
  echo "ansible is already installed"
fi

