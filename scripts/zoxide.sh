if ! command -v zoxide &> /dev/null; then
  export ZOXIDE_INSTALLED=false
else
  export ZOXIDE_INSTALLED=true
fi

zoxide_setup() {
  local opt=$1
  if [[ "$ZOXIDE_INSTALLED" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "zoxide is not installed"
    else
      log_debug "zoxide is not installed"
    fi
    return
  fi

  eval "$(zoxide init zsh)"
}

