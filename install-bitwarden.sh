#!/usr/bin/env bash

set -e

x="bash/lib/logging.sh"; f="$HOME/dotfiles/$x"; [ -f $f ] || f="/tmp/dotfiles/$x" && [ -f $f ] || (mkdir -p ${f%/*} && wget -qO $f "https://raw.githubusercontent.com/wlad031/dotfiles/refs/heads/master/$x"); source $f

GIT_REPO_URL="https://codeload.github.com/wlad031/dotfiles/zip/refs/heads/master"
DOWNLOAD_DIR="/tmp/dotfiles/ansible"

main() {
    log_info "Preparing environment..."
    rm -rf "$DOWNLOAD_DIR"
    mkdir -p "/tmp/downloads"
    mkdir -p "$DOWNLOAD_DIR"

    log_info "Downloading Ansible project from GitHub..."
    wget -q "$GIT_REPO_URL" -O /tmp/downloads/dotfiles.zip
    unzip -q /tmp/downloads/dotfiles.zip -d /tmp/dotfiles

    if [[ -d "/tmp/dotfiles/ansible" ]]; then
        mv "/tmp/dotfiles/ansible/*" "$DOWNLOAD_DIR/"
    else
        log_error "Ansible folder not found in the downloaded repo"
        exit 1
    fi

    log_info "Running Ansible playbook to install Bitwarden..."
    cd "$DOWNLOAD_DIR"
    ansible-playbook playbook.yml

    log_info "Playbook executed successfully"
}

main

