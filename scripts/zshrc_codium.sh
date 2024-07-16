if ! command -v codium &> /dev/null; then
  export CODIUM_INSTALLED=false
else
  export CODIUM_INSTALLED=true
fi

codium_setup() {
  if [[ "$CODIUM_INSTALLED" = false ]]; then
    log_error "codium is not installed"
    return
  fi

  alias code="codium"
}
