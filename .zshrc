# Uncomment for profiling this script
# zmodload zsh/zprof

# TODO: How about such logging, huh?

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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="robbyrussell"
if [ -f "$ZSH/oh-my-zsh.sh" ]; then
    source $ZSH/oh-my-zsh.sh
else
    log_error "Oh My Zsh isn't installed yet" 
fi

if [ -f "$SCRIPTS_DIR/macos-theme-observer.swift" ]; then
    ps aux | grep "macos-theme-observer.swift" | grep "alacritty-theme-changer.sh" | grep -v "grep" &> /dev/null
    if [ $? -ne 0 ]; then
        $SCRIPTS_DIR/macos-theme-observer.swift $SCRIPTS_DIR/alacritty-theme-changer.sh &>/dev/null & disown
    fi
fi

if [ -f "$HOME/.antigen.zsh" ]; then
    source ~/.antigen.zsh
#    antigen use oh-my-zsh &> /dev/null
    antigen bundle git &> /dev/null
    antigen bundle kazhala/dotbare &> /dev/null
    antigen bundle zsh-users/zsh-syntax-highlighting &> /dev/null
#    antigen theme https://github.com/denysdovhan/spaceship-zsh-theme spaceship
#    antigen theme robbyrussell &> /dev/null
    antigen apply
else
    log_error "Antigen isn't installed yet"
fi

git_autocommit() {
    git commit -m "[autocommit] $(date +'%Y-%m-%dT%H:%M:%S%z')" 
}

gitac() {
    git add . && git_autocommit
}

gitacp() {
    gitac && git push
}

[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

bkp() {
    FILE=$1
    BKP="$FILE.bkp"
    echo "Backup file $FILE to $BKP"
    cp $FILE $BKP
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
else
    alias vim="nvim"
fi

if ! command -v codium &> /dev/null
then
else
    alias code="codium"
fi

if ! command -v exa &> /dev/null
then
else
    alias ls="exa"
    alias tree="exa --tree"
fi

if ! command -v bat &> /dev/null
then
else
    alias cat="bat"
fi

if ! command -v tmux &> /dev/null 
then
else
    TMUX_DIR="$HOME/.tmux"
    TMUX_PLUGINS_DIR="$TMUX_DIR/plugins"

    if [[ -d "$TMUX_PLUGINS_DIR/tpm" ]] 
    then
    else
        git clone https://github.com/tmux-plugins/tpm "$TMUX_PLUGINS_DIR/tpm"
        log_info "Tmux plugin manager is installed"
    fi

    alias tls="tmux ls"

    tmux_create_session_if_not_exists() {
        SESSION=$1
        tmux has-session -t $SESSION 2>/dev/null
        if [ $? != 0 ]; then
            tmux new-session -d -t $SESSION
            tmux rename-window -t 1 main
        fi
    }

    default_tmux_session="main"

    if [[ "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" ]]
    then 
      ZSH_TMUX_AUTOSTART=true
      tmux_create_session_if_not_exists $default_tmux_session
      tmux attach-session -t $default_tmux_session
    fi

    tmux_create_session_and_attach() {
        if ! [ -z "$1" ]; then 
            SESSION=$1
        else
            SESSION=$default_tmux_session
        fi
        tmux_create_session_if_not_exists $SESSION
        tmux attach-session -t $SESSION || tmux switch-client -t $SESSION
    }

    alias at=tmux_create_session_and_attach
fi

if ! command -v fnm &> /dev/null
then
  log_warn "fnm (Node.js version manager) is not installed"
else
    eval "$(fnm env --use-on-cd)"
fi

if ! command -v pyenv &> /dev/null
then
  log_warn "pyenv (Python version manager) is not installed"
else
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    export PIPX_DEFAULT_PYTHON="$PYENV_ROOT/versions/3.12.2/bin/python"
fi

if ! command -v docker &> /dev/null
then
  log_warn "Docker is not installed"
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
  log_warn "Coursier is not installed"
else 
  COURSIER_DIR="$HOME/Library/Application Support/Coursier"
  if [[ -d "$COURSIER_DIR" ]]
  then 
    export PATH="$PATH:$COURSIER_DIR/bin"
  else
    log_error "Coursier installed in an unknown directory"
  fi
fi

export LOGSEQ_DIR="$HOME/Logseq"
export LEDGER_DIR="$HOME/ledger"
export LEDGER_FILE="$LEDGER_DIR/2024.hledger"

eval "$(zoxide init zsh)"

# Uncomment for profiling this script
# zprof

