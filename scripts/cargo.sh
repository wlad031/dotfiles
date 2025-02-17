if ! command -v cargo &> /dev/null; then
  if [[ -f "$HOME/.cargo/env" ]]; then
    export CARGO_INSTALLED=true
  else
    export CARGO_INSTALLED=false
  fi
else
  export CARGO_INSTALLED=true
fi

cargo_setup() {
  local opt=$1
  if [[ "$CARGO_INSTALLED" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "cargo is not installed"
    else
      log_debug "cargo is not installed"
    fi
    return
  fi

  export CARGO_DIR="$HOME/.cargo"
  if [[ -f "$CARGO_DIR/env" ]]; then
    source_safe "$CARGO_DIR/env"
  fi
}

