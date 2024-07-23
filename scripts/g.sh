if ! command -v g &> /dev/null; then
  export G_INSTALLED=false
else
  export G_INSTALLED=true
fi

g_setup() {
  if [[ "$G_INSTALLED" = false ]]; then
    log_error "g is not installed"
    return
  fi

  source_safe "$HOME/.g/env"
}
