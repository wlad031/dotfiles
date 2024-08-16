RANCHER_DIR="$HOME/.rd"
if [[ -d "$RANCHER_DIR" ]]; then
  export RANCHER_INSTALLED=true
else
  export RANCHER_INSTALLED=false
fi

rancher_setup() {
  local opt=$1
  if [[ "$RANCHER_INSTALLED" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "rancher is not installed"
    else
      log_debug "rancher is not installed"
    fi
  fi

  __docker_change_host_rancher() {
    __docker_set_sock "$RANCHER_DIR/docker.sock"
  }

  export PATH="$PATH:$RANCHER_DIR/bin"
  export RANCHER_DIR
}

