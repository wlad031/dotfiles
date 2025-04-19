#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

USERNAME=$(whoami)
DRY_RUN=0
VERBOSE=0
ADOPT=0
NO_COLOR=''
TAGS=()

RED='' GREEN='' YELLOW='' NOFORMAT=''

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [options]

This script installs dotfiles by creating symlinks using GNU Stow.
It handles common and tag-based configurations.

Available options:

-h, --help        Print this help and exit
-v, --verbose     Enable verbose output
-n, --dry-run     Perform a dry run without making changes
--adopt           (Use with care!)  Import existing files into stow package
--no-color        Disable colored output
--username USER   Specify username (default: current username)
--tags TAGS...    Specify one or more tags to apply (order matters)
EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
}

setup_colors() {
  if [[ -t 1 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[1;33m'
  fi
}

msg() {
  echo -e "${1-}"
}

die() {
  local message=$1
  local code=${2-1}
  msg "${RED}$message${NOFORMAT}"
  exit "$code"
}

parse_params() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help) usage ;;
      -v|--verbose) VERBOSE=1 ;;
      -n|--dry-run) DRY_RUN=1 ;;
      --adopt) ADOPT=1 ;;
      --no-color) NO_COLOR=1 ;;
      --username) USERNAME="$2"; shift ;;
      --tags)
        shift
        while [[ $# -gt 0 && "$1" != -* ]]; do
          TAGS+=("$1")
          shift
        done
        continue
        ;;
      -?*) die "Unknown option: $1" ;;
      *) break ;;
    esac
    shift
  done
}

stow_package() {
  local package_dir=$1
  local package_name=$2
  local target_dir=$3

  if [[ -d "$package_dir/$package_name" ]]; then
    local stow_cmd=(stow --override=.* -d "$package_dir" -t "$target_dir" "$package_name")

    [[ "$DRY_RUN" == 1 ]] && stow_cmd+=("--simulate")
    [[ "$ADOPT" == 1 ]] && stow_cmd+=("--adopt")
    [[ "$VERBOSE" == 1 ]] && msg "${GREEN}Executing: ${stow_cmd[*]}${NOFORMAT}"

    "${stow_cmd[@]}"
  fi
}

parse_params "$@"
setup_colors

cd "$script_dir"

msg "${GREEN}Starting dotfiles installation...${NOFORMAT}"
msg "Username: $USERNAME"
msg "Tags: ${TAGS[*]:-(none)}"

if [[ ${#TAGS[@]} -eq 0 ]]; then
  die "No tags provided. Use --tags to specify at least one tag."
fi

for tag in "${TAGS[@]}"; do
  if [[ ! -d "$script_dir/hosts/$tag" ]]; then
    die "Tag folder not found: hosts/$tag"
  fi
done

if [[ "$(uname -s)" == "Darwin" ]]; then
  target_dir="$(dscl . -read /Users/"$USERNAME" NFSHomeDirectory | awk '{print $2}')"
else
  target_dir="$(getent passwd "$USERNAME" | cut -d: -f6)"
fi

msg "Target dir: $target_dir"

stow_package "common" "." "$target_dir"

for tag in "${TAGS[@]}"; do
  stow_package "hosts" "$tag" "$target_dir"
done

msg "${GREEN}Dotfiles installation completed!${NOFORMAT}"

