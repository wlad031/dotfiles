if ! command -v codium &> /dev/null; then
  export CODIUM_INSTALLED=false
else
  export CODIUM_INSTALLED=true
fi

codium_setup() {
  local opt=$1
  if [[ "$CODIUM_INSTALLED" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "codium is not installed"
    else
      log_debug "codium is not installed"
    fi
    return
  fi

  alias code="codium"
}
