#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

# Get the directory of the script
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

# Initialize variables
HOSTNAME=$(hostname)
USERNAME=$(whoami)
DRY_RUN=0
VERBOSE=0
ADOPT=0
RED='' GREEN='' YELLOW=''
NOFORMAT=''

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [options]

This script installs dotfiles by creating symlinks using GNU Stow.
It handles common, host-specific, and user-specific configurations.

Available options:

-h, --help        Print this help and exit
-v, --verbose     Enable verbose output
-n, --dry-run     Perform a dry run without making changes
--adopt           (Use with care!)  Import existing files into stow package
                  from target.  Please read stow docs before using.
--no-color        Disable colored output
--hostname HOST   Specify hostname (default: current hostname)
--username USER   Specify username (default: current username)
EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
}

setup_colors() {
  if [[ -t 1 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[1;33m'
  else
    NOFORMAT='' RED='' GREEN='' YELLOW=''
  fi
}

msg() {
  echo -e "${1-}"
}

die() {
  local message=$1
  local code=${2-1} # Default exit status is 1
  msg "${RED}$message${NOFORMAT}"
  exit "$code"
}

parse_params() {
  # Default values
  HOSTNAME=$(hostname)
  USERNAME=$(whoami)
  DRY_RUN=0
  VERBOSE=0
  ADOPT=0

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --verbose) VERBOSE=1 ;;
    -n | --dry-run) DRY_RUN=1 ;;
    --adopt) ADOPT=1 ;;
    --no-color) NO_COLOR=1 ;;
    --hostname)
      HOSTNAME="${2-}"
      shift
      ;;
    --username)
      USERNAME="${2-}"
      shift
      ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  return 0
}

stow_package() {
  local package_dir=$1
  local package_name=$2

  if [[ -d "$package_dir/$package_name" ]]; then
    local stow_cmd="stow --override=.* -d \"$package_dir\" -t \"$HOME\" \"$package_name\""

    if [[ "$DRY_RUN" == 1 ]]; then
      stow_cmd+=" --simulate"
    fi

    if [[ "$ADOPT" == 1 ]]; then
      stow_cmd+=" --adopt"
    fi

    if [[ "$VERBOSE" == 1 ]]; then
      stow_cmd+=" -v"
      msg "${GREEN}Executing: $stow_cmd${NOFORMAT}"
    fi

    eval "$stow_cmd"
  fi
}

parse_params "$@"
setup_colors

cd "$script_dir"

msg "${GREEN}Starting dotfiles installation...${NOFORMAT}"
msg "Hostname: $HOSTNAME"
msg "Username: $USERNAME"

# Stow common configurations
stow_package "common" "."

# Stow host-specific configurations
stow_package "hosts" "$HOSTNAME"

# Stow host-specific user configurations (if they exist)
if [ -d "hosts/$HOSTNAME/users/$USERNAME" ]; then
  stow_package "hosts/$HOSTNAME/users" "$USERNAME"
fi

msg "${GREEN}Dotfiles installation completed.${NOFORMAT}"

