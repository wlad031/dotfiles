# Uncomment for profiling this script
# zmodload zsh/zprof

export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.jetbrains:$PATH"

if [ -f "$HOME/.antigen.zsh" ]; then
    source "$HOME/.antigen.zsh"
    antigen init "$HOME/.antigenrc"
else
    log_error "Antigen isn't installed yet"
fi

setup_env "git"
setup_env "docker"
setup_env "tmux"
setup_env "sesh"
setup_env "lazygit"
setup_env "devmoji"

export PATH="$HOME/go/bin:$PATH"

#GO_DIR="$HOME/.go"
#if [[ -d "$GO_DIR" ]]
#then
#    export GOROOT="$GO_DIR/current"
#    export GOPATH="$GO_DIR"
#    export PATH="$GOROOT:$PATH"
#fi

FLUTTER_DIR="$HOME/.flutter"
if [[ -d "$FLUTTER_DIR" ]]
then
    export FLUTTERPATH="$FLUTTER_DIR"
    export PATH="$FLUTTERPATH/bin:$PATH"
fi

if ! command -v nvim &> /dev/null
then
  log_error "Neovim is not installed"
else
    alias vim="nvim"
fi

if ! command -v codium &> /dev/null
then
  log_error "VSCodium is not installed"
else
    alias code="codium"
fi

if ! command -v eza &> /dev/null
then
  log_error "eza is not installed"
else
  eza_default_args="--git --icons=auto"
  alias ls="eza $eza_default_args"
  alias tree="eza $eza_default_args --tree"
fi

if ! command -v bat &> /dev/null
then
  log_error "Bat is not installed"
else
    alias cat="bat"
fi


if ! command -v fnm &> /dev/null
then
  log_error "fnm (Node.js version manager) is not installed"
else
    eval "$(fnm env --use-on-cd)"
fi

if ! command -v pyenv &> /dev/null
then
  log_error "pyenv (Python version manager) is not installed"
else
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    export PIPX_DEFAULT_PYTHON="$PYENV_ROOT/versions/3.12.2/bin/python"
fi


if [ -f "$HOME/apps/google-cloud-sdk/path.zsh.inc" ];
then
    . "$HOME/apps/google-cloud-sdk/path.zsh.inc";
fi

if [ -f "$HOME/apps/google-cloud-sdk/completion.zsh.inc" ];
then
    . "$HOME/apps/google-cloud-sdk/completion.zsh.inc";
fi

RVM_DIR="$HOME/.rvm"
if [[ -d "$RVM_DIR" ]]
then
    # Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
    export PATH="$PATH:$RVM_DIR/bin"
    eval "$(brew shellenv)"
fi

if ! command -v coursier &> /dev/null
then
  log_error "Coursier is not installed"
else
  COURSIER_DIR="$HOME/Library/Application Support/Coursier"
  if [[ -d "$COURSIER_DIR" ]]
  then
    export PATH="$PATH:$COURSIER_DIR/bin"
  else
    log_error "Coursier installed in an unknown directory"
  fi
fi

if ! command -v thefuck &> /dev/null
then
  log_debug "the fuck is not installed"
else
  eval $(thefuck --alias)
fi

export LOGSEQ_DIR="$HOME/Logseq"
export LEDGER_DIR="$HOME/ledger"
export LEDGER_FILE="$LEDGER_DIR/2024.hledger"

###############################################################################
# fzf

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(fzf --zsh)"

# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_R_OPTS="--reverse"
export FZF_TMUX_OPTS="-p"

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

export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
export FZF_TMUX=1

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo $'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}

#if [ -n "$TMUX" ]; then
#   enable-fzf-tab
#fi

#zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

###############################################################################

###############################################################################
# fastfetch

if ! command -v fastfetch &> /dev/null
then
  log_debug "fastfetch is not installed"
else
  # TODO: Make this configurable
  # fastfetch
fi
###############################################################################

###############################################################################
# Oh My Posh
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/themes/zen.toml)"
fi
###############################################################################

###############################################################################
# zoxide
eval "$(zoxide init zsh)"
###############################################################################

###############################################################################

# Uncomment for profiling this script
# zprof


### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/vgerasimov/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
