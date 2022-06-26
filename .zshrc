# Uncomment for profiling this script
# zmodload zsh/zprof

export EDITOR='vim'
export LC_ALL=en_US.UTF-8

export PATH="/usr/local/opt/python@2/libexec/bin:$PATH"

export EMACSD_DIR="$HOME/.emacs.d/"

[ -f "$HOME/.secrets.sh" ] && source "$HOME/.secrets.sh"
[ -f "$HOME/.load_sdkman.sh" ] && source "$HOME/.load_sdkman.sh"
[ -f "$HOME/.load_gcsdk.sh" ] && source "$HOME/.load_gcsdk.sh"
[ -f "$HOME/.load_nvm.sh" ] && source "$HOME/.load_nvm.sh"
[ -f "$HOME/.load_pyenv.sh" ] && source "$HOME/.load_pyenv.sh"
[ -f "$HOME/.load_go.sh" ] && source "$HOME/.load_go.sh"

export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.jetbrains:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.coursier:$PATH"
export PATH="$HOME/Library/Application Support/Coursier/bin:$PATH"
export PATH="$HOME/.flutter/flutter/bin:$PATH"

# Load fzf for fuzzy searching
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Load antigen and it's plugins
source ~/.antigen.zsh
antigen init ~/.antigenrc

# Simply copies the file with suffix ".bkp"
bkp() {
    FILE=$1
    BKP="$FILE.bkp"
    echo "Backup file $FILE to $BKP"
    cp $FILE $BKP
}

# Load my custom aliases
if [ -f "$HOME/.sh-alias.sh" ]; then source "$HOME/.sh-alias.sh"; fi

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

# Uncomment for profiling this script
# zprof
