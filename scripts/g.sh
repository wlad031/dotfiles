if [[ -d "$HOME/.g" ]]; then
  export G_INSTALLED=true
else
  export G_INSTALLED=false
fi

g_setup() {
  if [[ "$G_INSTALLED" = false ]]; then
    log_error "g is not installed"
    return
  fi

  unalias g
  source_safe "$HOME/.g/env"
}
