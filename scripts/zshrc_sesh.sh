if ! command -v sesh &> /dev/null; then
  export SESH_INSTALLED=false
  log_debug "sesh is not installed"
else
  export SESH_INSTALLED=true
fi

sesh_setup() {
  if [[ "$TMUX_INSTALLED" = false ]]; then
    log_error "Tmux is not installed"
    return
  fi
  if [[ "$SESH_INSTALLED" = false ]]; then
    log_error "Sesh is not installed"
    return
  fi

  function sesh_connect() {
    sesh connect \"$(
      sesh list | fzf-tmux -p 55%,60% \
        --no-sort \
        --border-label ' sesh ' \
        --prompt '⚡  ' \
        --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
        --bind 'tab:down,btab:up' \
        --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list)' \
        --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t)' \
        --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c)' \
        --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z)' \
        --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
        --bind 'ctrl-d:execute(tmux kill-session -t {})+change-prompt(⚡  )+reload(sesh list)'
    )
  }

  function sesh_connect_i() {
    BUFFER="sesh_connect $BUFFER"
    zle accept-line
  }

  zle -N sesh_connect_i
  bindkey "^f" sesh_connect_i
}
