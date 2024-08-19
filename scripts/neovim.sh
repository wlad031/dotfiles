if ! command -v nvim &> /dev/null; then
  export NEOVIM_INSTALLED=false
else
  export NEOVIM_INSTALLED=true
fi

neovim_setup() {
  if [[ "$NEOVIM_INSTALLED" = false ]]; then
    log_error "Neovim is not installed"
    return
  fi

  alias vim="nvim"
  alias v="nvim"
  export EDITOR="nvim"
}
