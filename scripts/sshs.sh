if ! command -v sshs &> /dev/null; then
  export SSHS_INSTALLED=false
else
  export SSHS_INSTALLED=true
fi

sshs_setup() {
  local opt="$1"
  if [[ "$SSHS_INSTALLED" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "sshs is not installed"
    else
      log_debug "sshs is not installed"
    fi
    return
  fi
}
