if ! command -v lazygit &> /dev/null; then
  export LAZYGIT_INSTALLED=false
else
  export LAZYGIT_INSTALLED=true
fi

lazygit_setup() {
  if [[ "$GIT_INSTALLED" = false ]]; then
    log_debug "Git is not installed"
    return
  fi
  local opt=$1
  if [[ "$LAZYGIT_INSTALLED" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "lazygit is not installed"
    else
      log_debug "lazygit is not installed"
    fi
  fi

  alias lgit=lazygit
}
