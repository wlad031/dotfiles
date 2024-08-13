if [[ -d "$HOME/.atuin" ]]; then
  export ATUIN_INSTALLED=true
else
  export ATUIN_INSTALLED=false
fi

atuin_setup() {
  local opt=$1
  if [[ "$ATUIN_INSTALLED" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "atuin is not installed"
    else
      log_debug "atuin is not installed"
    fi
    return
  fi

  source_safe "$HOME/.atuin/bin/env"
  eval "$(atuin init zsh)"
}
