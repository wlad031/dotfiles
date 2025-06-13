command -v sesh &>/dev/null && export SESH_INSTALLED=true || export SESH_INSTALLED=false

sesh_setup() {
  local opt="${1:-optional}"
  if [[ "$TMUX_INSTALLED" = false ]]; then
    log_debug_or_error $opt "sesh: tmux is not installed"
    return
  fi
  if [[ "$SESH_INSTALLED" = false ]]; then
    log_debug_or_error $opt "sesh is not installed"
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
