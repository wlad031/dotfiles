if ! command -v eza &> /dev/null; then
  export EZA_INSTALLED=false
else
  export EZA_INSTALLED=true
fi

eza_setup() {
  if [[ "$EZA_INSTALLED" = false ]]; then
    log_error "eza is not installed"
    return
  fi

  eza_default_args="-la --git --git-repos-no-status --icons=auto --time-style=long-iso"
  alias ls="eza $eza_default_args"
  alias tree="eza $eza_default_args --tree"
}
