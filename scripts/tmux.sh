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

  _tmux_check_tpm
}

_tmux_check_tpm() {
  if [[ ! -d "$TMUX_TPM_DIR" ]]; then
    log_error "TPM - Tmux plugin manager is not found"
    echo "Please install it like that:"
    echo ""
    echo "    git clone https://github.com/tmux-plugins/tpm $TMUX_PLUGINS_DIR/tpm"
    echo ""
  fi
}

