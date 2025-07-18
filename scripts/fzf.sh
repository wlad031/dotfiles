if ! command -v fzf &> /dev/null; then
  export FZF_INSTALLED=false
else
  export FZF_INSTALLED=true
fi

fzf_setup() {
  local opt=$1
  if [[ "$FZF_INSTALLED" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "fzf is not installed"
    else
      log_debug "fzf is not installed"
    fi
    return
  fi

  v=$(fzf --version)
  current_version=$(echo "$v" | sed 's/ (.*)//g' | sed 's/\.//g')
  required_version=$(echo "0.59.0" | sed 's/\.//g')

  if [[ "$current_version" -ge "$required_version" ]]; then
    eval "$(fzf --zsh)"
    return
  fi
  log_debug "fzf version is $v, fzf shell integration cannot be installed"
}

# TODO: Write my own preview function.
# It should accept a file and based on it's
# mime type, it should use the appropriate
# command to preview it.
# file -b --mime-type

  # TODO: Checks for fd is installed.

  # -- Use fd instead of fzf --
  export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"

  # morhetz/gruvbox
  export FZF_DEFAULT_OPTS='--color=bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934'

  # export FZF_DEFAULT_OPTS="--height 80% --layout=reverse --border --preview '/Users/vgerasimov/dotfiles/scripts/fzf-preview.sh {}'"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
  export FZF_CTRL_R_OPTS="--reverse"
  export TMUX_FZF_PREVIEW=0

  # Use fd (https://github.com/sharkdp/fd) for listing path candidates.
  # - The first argument to the function ($1) is the base path to start traversal
  # - See the source code (completion.{bash,zsh}) for the details.
  _fzf_compgen_path() {
    fd --hidden --exclude .git . "$1"
  }

  # Use fd to generate the list for directory completion
  _fzf_compgen_dir() {
    fd --type=d --hidden --exclude .git . "$1"
  }

  # TODO: Checks for bat and eza are installed.
  export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
  export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

  if [[ "$TMUX_INSTALLED" = true ]]; then
    export FZF_TMUX=1
    export FZF_TMUX_OPTS="-p"
  fi

  # Advanced customization of fzf options via _fzf_comprun function
  # - The first argument to the function is the name of the command.
  # - You should make sure to pass the rest of the arguments to fzf.
  _fzf_comprun() {
    local command=$1
    shift

    case "$command" in
      cd)           fzf --preview 'eza --tree --color=always {} | head -200'   "$@" ;;
      export|unset) fzf --preview "eval 'echo $'{}"                            "$@" ;;
      ssh)          fzf --preview 'dig {}'                                     "$@" ;;
      *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
    esac
  }

  #if [ -n "$TMUX" ]; then
  #   enable-fzf-tab
  #fi

  #zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
