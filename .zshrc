# Uncomment for profiling this script
# zmodload zsh/zprof

###############################################################################
# Logging

# TODO: Find some better way to do logging

CL_RED='\033[0;31m'
CL_BLUE='\033[0;34m'
CL_LGRAY='\033[0;37m'
CL_NO='\033[0m'

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
        echo -e "${CL_RED}[INFO ]${CL_NO} $*"
    fi
}

log_error() {
    if "$ZSHRC_LOG_ERROR" || "$ZSHRC_LOG_DEBUG"; then
        echo -e "${CL_RED}[ERROR]${CL_NO} $*"
    fi
}

log_debug() {
    if "$ZSHRC_LOG_DEBUG"; then
        echo -e "${CL_LGRAY}[DEBUG]${CL_NO} $*"
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
is_tmux_installed=false
if [ ! -z "$TMUX_AUTO_ATTACH" ]; then
else
  TMUX_AUTO_ATTACH=false
fi

if ! command -v tmux &> /dev/null
then
  log_error "Tmux is not installed"
  is_tmux_installed=false
else
  is_tmux_installed=true
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

###############################################################################
# sesh

if ! command -v sesh &> /dev/null
then
  log_debug "sesh is not installed"
else
  if [[ "$is_tmux_installed" = true ]]; then
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
  fi
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

  if ! command -v devmoji &> /dev/null
  then
    log_debug "devmoji is not installed"
  else
    gitcoji() {
      local msg
      msg=$1
      git commit -m "$(devmoji --commit -t "$msg")"
    }
  fi
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


###############################################################################
# Docker

# Colima
is_colima_installed=false
COLIMA_DIR="$HOME/.colima"
if ! command -v colima &> /dev/null
then
  is_colima_installed=false
else
  is_colima_installed=true
fi

# Rancher Desktop
is_rancher_installed=false
RANCHER_DIR="$HOME/.rd"
if [[ -d "$RANCHER_DIR" ]]; then
  export PATH="$PATH:$RANCHER_DIR/bin"
  is_rancher_installed=true
else
  is_rancher_installed=false
fi

# Common
if ! command -v docker &> /dev/null
then
  log_error "Docker is not installed"
else
  local default_host
  if [[ "$is_colima_installed" = false && "$is_colima_installed" = false ]]; then
    log_error "None of [colima, rancher] is installed"
  elif [[ "$is_rancher_installed" = true ]]; then
    default_host="rancher"
  elif [[ "$is_colima_installed" = true ]]; then
    default_host="colima"
  fi

  function dock() {
    if [[ "$@" == "ps" ]]; then
      command docker ps --format 'table {{.Names}}\t{{.Status}} : {{.RunningFor}}\t{{.ID}}\t{{.Image}}'
    elif [[ "$@" == "psa" ]]; then
      # docker ps -a includes all containers
      command docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Size}}\n{{.ID}}\t{{.Image}}{{if .Ports}}{{with $p := split .Ports ", "}}\t{{len $p}} port(s) on {{end}}{{- .Networks}}{{else}}\tNo Ports on {{ .Networks }}{{end}}\n'
    elif [[ "$@" == "psnet" ]]; then
      # docker ps with network information
      command docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Networks}}\n{{.ID}}{{if .Ports}}{{with $p := split .Ports ", "}}{{range $p}}\t\t{{println .}}{{end}}{{end}}{{else}}\t\t{{println "No Ports"}}{{end}}'
    elif [[ "$1" == "host" ]]; then # TODO: Extract this as a separate function, at least
      if [[ "$2" == "rancher" ]]; then
        if [ "$is_rancher_installed" = true ]; then
          docker_sock="$RANCHER_DIR/docker.sock"
          if [ -e "$docker_sock" ]; then
            export DOCKER_HOST="unix://$docker_sock"
            echo "Docker environment updated"
          else
            log_error "$docker_sock not found"
          fi
        else
          log_error "Rancher is not installed"
        fi
      elif [[ "$2" == "colima" ]]; then
        if [ "$is_colima_installed" = true ]; then
          docker_sock="$COLIMA_DIR/${3:-default}/docker.sock"
          if [ -e "$docker_sock" ]; then
            export DOCKER_HOST="unix://$docker_sock"
            echo "Docker environment updated"
          else
            log_error "$docker_sock not found"
          fi
        else
          log_error "Colima is not installed"
        fi
      elif [[ ! -z "$2" ]]; then
        log_error "Unknown docker host: $2"
      fi
      echo "DOCKER_HOST: $DOCKER_HOST"
    else
      command docker "$@"
    fi
  }

  if [[ "$default_host" == "rancher" ]]; then
    log_debug "Setting rancher as Docker host"
    dock host rancher > /dev/null
  elif [[ "$default_host" == "colima" ]]; then
    log_debug "Setting colima default as Docker host"
    dock host colima > /dev/null
  fi

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

# TODO: What is that?
# g shell setup
if [ -f "${HOME}/.g/env" ]; then
    . "${HOME}/.g/env"
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
  # TODO: Make this configurable
  # fastfetch
fi
###############################################################################

###############################################################################
# zoxide
eval "$(zoxide init zsh)"
###############################################################################

###############################################################################

# Uncomment for profiling this script
# zprof

