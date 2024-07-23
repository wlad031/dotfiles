if ! command -v fastfetch &> /dev/null; then
  export FASTFETCH_INSTALLED=true
else
  export FASTFETCH_INSTALLED=false
fi

fastfetch_setup() {
  if [[ "$WELCOME_SCREEN_ENABLED" = false ]]; then
    return
  fi

  if [[ "$FASTFETCH_INSTALLED" = false ]]; then
    log_error "fastfetch is not installed"
    return
  fi

  fastfetch
}
