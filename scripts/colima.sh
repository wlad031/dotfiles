if ! command -v colima &> /dev/null; then
  export COLIMA_INSTALLED=false
else
  export COLIMA_INSTALLED=true
fi

colima_setup() {
  local opt=$1
  if [[ "$COLIMA_INSTALLED" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "colima is not installed"
    else
      log_debug "colima is not installed"
    fi
  fi
  
  __docker_change_host_colima() {
    __docker_set_sock "$COLIMA_DIR/${1:-default}/docker.sock"
  }

  export COLIMA_DIR="$HOME/.colima"
}
