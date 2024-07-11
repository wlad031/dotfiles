if ! command -v devmoji &> /dev/null; then
  export DEVMOJI_INSTALLED=false
else
  export DEVMOJI_INSTALLED=true
fi

devmoji_setup() {
  if [[ "$DEVMOJI_INSTALLED" = false ]]; then
    log_error "Devmoji is not installed"
    return
  fi

  if [[ "$GIT_INSTALLED" = true ]]; then
    gitcoji() {
      local msg
      msg=$1
      git commit -m "$(devmoji --commit -t "$msg")"
    }
  else
    log_debug "Git is not installed"
  fi
}
