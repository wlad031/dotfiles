if ! command -v bat &> /dev/null; then
  export BAT_INSTALLED=false
else
  export BAT_INSTALLED=true
fi

bat_setup() {
  if [[ "$BAT_INSTALLED" = false ]]; then
    log_error "Bat is not installed"
    return
  fi

  alias cat="bat"
}
