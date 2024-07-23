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
  DIR="$HOME/.config/yazi/flavors"
  if [[ ! -d "$DIR" ]]; then
    log_error "yazi flavors directory not found"
    echo "Please install it like that:"
    echo ""
    echo "    git clone git@github.com:yazi-rs/flavors.git $DIR"
    echo ""
  fi
}

_yazi_check_plugins() {
  DIR="$HOME/.config/yazi/plugins"
  if [[ ! -d "$DIR" ]]; then
    log_error "yazi plugins directory not found"
    echo "Please create it like that:"
    echo ""
    echo "    mkdir $DIR"
    echo ""
    return
  fi

  yarn_check_plugins_bat
}

_yazi_check_plugins_bat() {
  DIR="$HOME/.config/yazi/plugins/bat.yazi"
  if [[ ! -d "$DIR" ]]; then
    log_error "yazi bat plugin not found"
    echo "Please install it like that:"
    echo ""
    echo "    git clone https://github.com/mgumz/yazi-plugin-bat.git $DIR"
    echo ""
  fi
}
