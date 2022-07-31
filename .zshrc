# Uncomment for profiling this script
# zmodload zsh/zprof

if [ -f "$HOME/.env" ]; then
  export $(echo $(cat "$HOME/.env" | sed 's/#.*//g'| xargs) | envsubst)
fi

export EDITOR='vim'
export LC_ALL=en_US.UTF-8

export SCRIPTS_DIR="$HOME/scripts"
export EMACSD_DIR="$HOME/.emacs.d/"

[ -f "$HOME/.secrets.sh" ] && source "$HOME/.secrets.sh"

export SDKMAN_DIR="$HOME/.sdkman"
[ -f "$SDKMAN_DIR/bin/sdkman-init.sh" ] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.jetbrains:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="robbyrussell"
if [ -f "$ZSH/oh-my-zsh.sh" ]; then
    source $ZSH/oh-my-zsh.sh
else
    echo "[ERROR] Oh My Zsh isn't installed yet" 
fi

if [ -f "$SCRIPTS_DIR/theme-observer.swift" ]; then
    ps aux | grep "theme-observer.swift" | grep "alacritty-theme-changer.sh" | grep -v "grep" &> /dev/null
    if [ $? -ne 0 ]; then
        $SCRIPTS_DIR/theme-observer.swift $SCRIPTS_DIR/alacritty-theme-changer.sh &>/dev/null & disown
    fi
fi


if [ -f "$HOME/.antigen.zsh" ]; then
    source ~/.antigen.zsh
    antigen use oh-my-zsh &> /dev/null
    antigen bundle git &> /dev/null
    antigen bundle kazhala/dotbare &> /dev/null
    antigen bundle zsh-users/zsh-syntax-highlighting &> /dev/null
#    antigen theme https://github.com/denysdovhan/spaceship-zsh-theme spaceship
#    antigen theme robbyrussell &> /dev/null
    antigen apply
else
    echo "[ERROR] Antigen isn't installed yet"
fi

[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

bkp() {
    FILE=$1
    BKP="$FILE.bkp"
    echo "Backup file $FILE to $BKP"
    cp $FILE $BKP
}

alias ll="ls -la"

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
    alias tls="tmux ls"

    tmux_create_session_if_not_exists() {
        SESSION=$1
        tmux has-session -t $SESSION 2>/dev/null
        if [ $? != 0 ]; then
            tmux new-session -d -t $SESSION
        fi
    }

    default_tmux_session="main"
    tmux_create_session_if_not_exists $default_tmux_session
    tmux attach-session -t $default_tmux_session

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
else
    eval "$(fnm env --use-on-cd)"
fi

# Uncomment for profiling this script
# zprof
