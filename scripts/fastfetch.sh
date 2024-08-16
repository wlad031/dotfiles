if ! command -v fastfetch &> /dev/null; then
  export FASTFETCH_INSTALLED=false 
else
  export FASTFETCH_INSTALLED=true
fi

fastfetch_setup() {
  if [[ "$WELCOME_SCREEN_ENABLED" = false ]]; then
    return
  fi

  if [[ "$FASTFETCH_INSTALLED" = false ]]; then
    log_error "fastfetch is not installed"
    return
  fi

  export FASTFETCH_DIR="$DOTFILES_DIR/.config/fastfetch"
  export FASTFETCH_CUSTOM="$FASTFETCH_DIR/custom.jsonc"

  fastfetch -c "$FASTFETCH_CUSTOM"
}
