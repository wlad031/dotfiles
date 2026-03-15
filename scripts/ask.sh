if ! command -v ask-sh &> /dev/null; then
  export ASK_SH_INSTALLED=false
else
  export ASK_SH_INSTALLED=true
fi

ask_sh_setup() {
  local opt=$1
  if [[ "$ASK_SH_INSTALLED" = false ]]; then
    function log() {
      if [[ "$opt" = "required" ]]; then
        log_error "$*"
      else
        log_debug "$*"
      fi
    }
    log "ask-sh is not installed"
    return
  fi
  eval "$(ask-sh --init)"
}
