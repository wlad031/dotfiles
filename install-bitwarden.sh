#!/usr/bin/env bash

set -e

x="bash/lib/logging.sh"; f="$HOME/dotfiles/$x"; [ -f $f ] || f="/tmp/dotfiles/$x" && [ -f $f ] || (mkdir -p ${f%/*} && wget -qO $f "https://raw.githubusercontent.com/wlad031/dotfiles/refs/heads/master/$x"); source $f

GIT_REPO_URL="https://codeload.github.com/wlad031/dotfiles/zip/refs/heads/master"

dir="/tmp/dotfiles"
downloads_dir="/tmp/downloads/dotfiles"
zip_file="$downloads_dir/dotfiles.zip"

main() {
    log_info "Preparing environment..."
    if [[ ! -d "$downloads_dir" ]]; then
      mkdir -p "$downloads_dir"
    fi
    if [[ -f "$zip_file" ]]; then
      rm -rf "$zip_file"
    fi
    if [[ -d "$dir" ]]; then
      rm -rf "$dir/ansible"
    fi
    mkdir -p "$dir/ansible"

    log_info "Downloading Ansible project from GitHub..."
    wget -q "$GIT_REPO_URL" -O "$zip_file"
    unzip -q "$zip_file" -d "$downloads_dir"

    if [[ -d "$dir" ]]; then
        mv "$downloads_dir/dotfiles-master/ansible/*" "$dir/ansible"
    else
        log_error "Ansible folder not found"
        exit 1
    fi

    log_info "Running Ansible playbook to install Bitwarden..."
    cd "$dir/ansible"
    ansible-playbook playbooks/playbook.yml

    log_info "Playbook executed successfully"
}

main

