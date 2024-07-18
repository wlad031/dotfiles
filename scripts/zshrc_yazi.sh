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

  _yazi_check_flavors
}

_yazi_check_flavors() {
  YAZI_FLAVORS_DIR="$HOME/.config/yazi/flavors"
  if [[ ! -d "$YAZI_FLAVORS_DIR" ]]; then
    log_error "yazi flavors directory not found"
    echo "Please install it like that:"
    echo ""
    echo "    git clone git@github.com:yazi-rs/flavors.git $YAZI_FLAVORS_DIR"
    echo ""
  fi
}
