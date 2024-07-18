if ! command -v cargo &> /dev/null; then
  export CARGO_INSTALLED=false
else
  export CARGO_INSTALLED=true
fi

cargo_setup() {
  if [[ "$CARGO_INSTALLED" = false ]]; then
    log_error "cargo is not installed"
    return
  fi

  CARGO_DIR="$HOME/.cargo"
  if [[ -f "$CARGO_DIR/env" ]]; then
    source_safe "$CARGO_DIR/env"
  fi
}

