if ! command -v bat &> /dev/null; then
  export BAT_INSTALLED=false
else
  export BAT_INSTALLED=true
fi
if ! command -v batcat &> /dev/null; then
  export BATCAT_INSTALLED=false
else
  export BATCAT_INSTALLED=true
fi

bat_setup() {
  local opt=$1
  if [[ "$BAT_INSTALLED" = false && "$BATCAT_INSTALLED" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "Bat is not installed"
    else
      log_debug "Bat is not installed"
    fi
    return
  fi

  if [[ "$BAT_INSTALLED" = true ]]; then
    alias cat="bat"
  fi
  if [[ "$BATCAT_INSTALLED" = true ]]; then
    alias cat="batcat"
  fi
}
