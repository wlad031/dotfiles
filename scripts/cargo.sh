if ! command -v cargo &> /dev/null; then
  export CARGO_INSTALLED=false
else
  export CARGO_INSTALLED=true
fi

cargo_setup() {
  if [[ "$CARGO_INSTALLED" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "cargo is not installed"
    else
      log_debug "cargo is not installed"
    fi
    return
  fi

  export CARGO_DIR="$HOME/.cargo"
  source_safe "$CARGO_DIR/env"
}

