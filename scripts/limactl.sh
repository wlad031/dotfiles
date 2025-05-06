if ! command -v limactl &> /dev/null; then
  export LIMA_INSTALLED=false
else
  export LIMA_INSTALLED=true
fi

lima_setup() {
  local opt=$1
  if [[ "$LIMA_INSTALLED" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "lima is not installed"
    else
      log_debug "lima is not installed"
    fi
  fi
  
  __docker_change_host_lima() {
    __docker_set_sock "$LIMA_DIR/${1:-default}/sock/docker.sock"
  }

  export LIMA_DIR="$HOME/.lima"
}
