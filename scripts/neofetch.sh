if ! command -v neofetch &> /dev/null; then
  export NEOFETCH_INSTALLED=false
else
  export NEOFETCH_INSTALLED=true
fi

neofetch_setup() {
  if [[ "$WELCOME_SCREEN_ENABLED" = false ]]; then
    return
  fi

  if [[ "$NEOFETCH_INSTALLED" = false ]]; then
    log_error "neofetch is not installed"
    return
  fi

  neofetch
}
