if ! command -v yazi &> /dev/null; then
  export YAZI_INSTALLED=false
else
  export YAZI_INSTALLED=true
fi

yazi_setup() {
  if [[ "$YAZI_INSTALLED" = false ]]; then
    log_error "yazi is not installed"
    return
  fi

  function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      cd -- "$cwd"
    fi
    rm -f -- "$tmp"
  }
}
