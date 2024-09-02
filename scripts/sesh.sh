if ! command -v sesh &> /dev/null; then
  export SESH_INSTALLED=false
else
  export SESH_INSTALLED=true
fi

sesh_setup() {
  if [[ "$TMUX_INSTALLED" = false ]]; then
    log_debug "sesh: tmux is not installed"
    return
  fi
  if [[ "$SESH_INSTALLED" = false ]]; then
    log_error "sesh is not installed"
    return
  fi

  function sesh-sessions() {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    [[ -z "$session" ]] && return
    sesh connect $session
  }

  zle -N sesh-sessions
  bindkey "^f" sesh-sessions
}
