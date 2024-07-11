if ! command -v tmux &> /dev/null; then
  export TMUX_INSTALLED=false
else
  export TMUX_INSTALLED=true
fi

tmux_setup() {
  if [[ "$TMUX_INSTALLED" = false ]]; then
    log_error "Tmux not installed"
    return
  fi

  export TMUX_DIR="$HOME/.tmux"
  export TMUX_PLUGINS_DIR="$TMUX_DIR/plugins"
  export TMUX_TPM_DIR="$TMUX_PLUGINS_DIR/tpm"

  alias t='tmux attach || tmux new-session'
  alias ta='tmux attach'
  alias tn='tmux new-session'
  alias tls='tmux list-sessions'

  _tmux_install_tpm_if_needed
}

_tmux_install_tpm_if_needed() {
  if [[ ! -d "$TMUX_TPM_DIR" ]]; then
    git clone https://github.com/tmux-plugins/tpm "$TMUX_PLUGINS_DIR/tpm"
    log_info "Tmux plugin manager is installed"
  fi
}

