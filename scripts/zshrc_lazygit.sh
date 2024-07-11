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
  if [[ "$LAZYGIT_INSTALLED" = false ]]; then
    log_error "Lazyit is not installed"
    return
  fi

  alias lgit=lazygit
}
