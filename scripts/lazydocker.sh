if ! command -v lazydocker &> /dev/null; then
  export LAZYDOCKER_INSTALLED=false
else
  export LAZYDOCKER_INSTALLED=true
fi

lazydocker_setup() {
  local opt=$1
  if [[ "$LAZYDOCKER_INSTALLED" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "lazydocker is not installed"
    else
      log_debug "lazydocker is not installed"
    fi
  fi

  if [[ "$DOCKER_INSTALLED" = false ]]; then
    log_error "lazydocker requires docker"
    return
  fi

  alias ldocker=lazydocker
}

