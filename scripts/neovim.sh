if ! command -v nvim &> /dev/null; then
  export NEOVIM_INSTALLED=false
else
  export NEOVIM_INSTALLED=true
fi

neovim_setup() {
  local opt=$1
  if [[ "$NEOVIM_INSTALLED" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "Neovim is not installed"
    else
      log_debug "Neovim is not installed"
    fi
  fi

  alias vim="nvim"
  alias v="nvim"
  export EDITOR="nvim"
}
