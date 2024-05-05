# Uncomment for profiling this script
# zmodload zsh/zprof

###############################################################################
# Logging

# TODO: Find some better way to do logging

if [ ! -z "$ZSHRC_LOG_INFO" ]; then
else
    ZSHRC_LOG_INFO=true
fi
if [ ! -z "$ZSHRC_LOG_ERROR" ]; then
else
    ZSHRC_LOG_ERROR=true
fi
if [ ! -z "$ZSHRC_LOG_DEBUG" ]; then
else
    ZSHRC_LOG_DEBUG=false
fi

log_info() {
    if "$ZSHRC_LOG_INFO" || "$ZSHRC_LOG_ERROR" || "$ZSHRC_LOG_DEBUG"; then
        echo "[INFO ] $*"
    fi
}

log_error() {
    if "$ZSHRC_LOG_ERROR" || "$ZSHRC_LOG_DEBUG"; then
        echo "[ERROR] $*"
    fi
}

log_debug() {
    if "$ZSHRC_LOG_DEBUG"; then
        echo "[DEBUG] $*"
    fi
}

###############################################################################

renv() {
    file=$1
    log_debug "Loading env file: $file"
    export $(echo $(cat "$file" | sed 's/#.*//g'| xargs) | envsubst)
}

if [ -f "$HOME/.env" ]; then
    renv "$HOME/.env"
fi

export UID=$(id -u)
export GID=$(id -g)

export EDITOR='vim'
export LC_ALL=en_US.UTF-8

export SCRIPTS_DIR="$HOME/scripts"
export EMACSD_DIR="$HOME/.emacs.d/"

alias xx='exit'
[ -f "$HOME/.secrets.sh" ] && source "$HOME/.secrets.sh"

export SDKMAN_DIR="$HOME/.sdkman"
[ -f "$SDKMAN_DIR/bin/sdkman-init.sh" ] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.jetbrains:$PATH"

if [ -f "$HOME/.antigen.zsh" ]; then
    source ~/.antigen.zsh
    antigen init ~/.antigenrc
else
    log_error "Antigen isn't installed yet"
fi


###############################################################################
# Tmux

if [ ! -z "$TMUX_AUTO_ATTACH" ]; then
else
  TMUX_AUTO_ATTACH=false
fi

if ! command -v tmux &> /dev/null 
then
  log_error "Tmux is not installed"
else
    TMUX_DIR="$HOME/.tmux"
    TMUX_PLUGINS_DIR="$TMUX_DIR/plugins"

    if [[ -d "$TMUX_PLUGINS_DIR/tpm" ]] 
    then
    else
        git clone https://github.com/tmux-plugins/tpm "$TMUX_PLUGINS_DIR/tpm"
        log_info "Tmux plugin manager is installed"
    fi

    # Attaches tmux to the last session; creates a new session if none exists.
    alias t='tmux attach || tmux new-session'
    # Attaches tmux to a session (example: ta portal)
    alias ta='tmux attach'
    # Creates a new session
    alias tn='tmux new-session'
    # Lists all ongoing sessions
    alias tls='tmux list-sessions'
fi

###############################################################################

if ! command -v git &> /dev/null 
then
  log_error "Git is not installed"
else
  git_autocommit() {
      git commit -m "[autocommit] $(date +'%Y-%m-%dT%H:%M:%S%z')" 
  }

  gitac() {
      git add . && git_autocommit
  }

  gitacp() {
      gitac && git push
  }
fi

[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

bkp() {
    FILE=$1
    BKP="$FILE.bkp"
    echo "Copying $FILE to $BKP"
    cp $FILE $BKP
    echo "Backup file $FILE to $BKP"
}

alias ll="ls -la"

GO_DIR="$HOME/.go"
if [[ -d "$GO_DIR" ]]
then
    export GOROOT="$GO_DIR/current"
    export GOPATH="$GO_DIR"
    export PATH="$GOROOT:$PATH"
fi

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
    alias ls="eza"
    alias tree="eza --tree"
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

###############################################################################
# Colima

if ! command -v colima &> /dev/null
then
  log_error "Colima is not installed"
else
  export COLIMA_DIR="$HOME/.colima"
  # TODO: Actually, "./docker/" part is dependent on colima's VMs,
  #  so, it might have sense to make it more generic.
  export DOCKER_HOST="unix://$COLIMA_DIR/docker/docker.sock"
fi

###############################################################################

###############################################################################
# Docker

if ! command -v docker &> /dev/null
then
  log_error "Docker is not installed"
else
    function dock() {
      if [[ "$@" == "ps" ]]; then
        command docker ps --format 'table {{.Names}}\t{{.Status}} : {{.RunningFor}}\t{{.ID}}\t{{.Image}}'
      elif [[ "$@" == "psa" ]]; then
        # docker ps -a includes all containers
        command docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Size}}\n{{.ID}}\t{{.Image}}{{if .Ports}}{{with $p := split .Ports ", "}}\t{{len $p}} port(s) on {{end}}{{- .Networks}}{{else}}\tNo Ports on {{ .Networks }}{{end}}\n'
      elif [[ "$@" == "psnet" ]]; then
        # docker ps with network information
        command docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Networks}}\n{{.ID}}{{if .Ports}}{{with $p := split .Ports ", "}}{{range $p}}\t\t{{println .}}{{end}}{{end}}{{else}}\t\t{{println "No Ports"}}{{end}}'
      else
        command docker "$@"
      fi
    }

    if ! command -v lazydocker &> /dev/null
    then
      log_error "Lazydocker is not installed"
    else
      alias ldocker=lazydocker
    fi
fi

###############################################################################

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

if ! command -v lazygit &> /dev/null
then
  log_error "Lazygit is not installed"
else
  alias lgit=lazygit
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
  fastfetch
fi

###############################################################################

# Uncomment for profiling this script
# zprof
