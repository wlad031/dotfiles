if ! command -v coursier &> /dev/null; then
  export COURSIER_INSTALLED=false
else
  export COURSIER_INSTALLED=true
fi

coursier_setup() {
  if [[ "$COURSIER_INSTALLED" = false ]]; then
    log_error "Coursier is not installed"
    return
  fi

  if [[ "$OSTYPE" == "darwin"* ]]; then
    COURSIER_DIR="$HOME/Library/Application Support/Coursier"
    if [[ -d "$COURSIER_DIR" ]]; then
      export PATH="$PATH:$COURSIER_DIR/bin"
    else
      log_error "Coursier installed in an unknown directory, not found: $COURSIER_DIR"
    fi
  fi
}
