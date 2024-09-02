if ! command -v thefuck &> /dev/null; then
  export THEFUCK_INSTALLED=false
else
  export THEFUCK_INSTALLED=true
fi

thefuck_setup() {
  if [[ "$THEFUCK_INSTALLED" = false ]]; then
    log_error "thefuck is not installed"
    return
  fi

  eval $(thefuck --alias)

  alias tf='fuck'
}
