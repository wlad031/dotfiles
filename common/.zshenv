###############################################################################
# Setting logging level
export ZSHRC_LOG_INFO=true
export ZSHRC_LOG_ERROR=true
export ZSHRC_LOG_DEBUG=false
export WELCOME_SCREEN_ENABLED=true
###############################################################################

###############################################################################
# Common variables
export HOSTNAME=$(hostname)
export USERNAME=$(whoami)
export UID=$(id -u)
export GID=$(id -g)
export EDITOR='vim'
export LC_ALL=en_US.UTF-8
###############################################################################

###############################################################################
# Common PATH changes
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
###############################################################################

###############################################################################
# ZSH History
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt SHARE_HISTORY
###############################################################################

