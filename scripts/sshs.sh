if ! command -v sshs &> /dev/null; then
  export SSHS_INSTALLED=false
else
  export SSHS_INSTALLED=true
fi

sshs_setup() {
  if [[ "$SSHS_INSTALLED" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "sshs is not installed"
    else
      log_debug "sshs is not installed"
    fi
    return
  fi
}
