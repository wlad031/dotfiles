###############################################################################
# Setting logging level
export LOG_INFO_ENABLED=true
export LOG_ERROR_ENABLED=true
export LOG_DEBUG_ENABLED=false
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

if [[ -f "$HOME/.zshenv_host" ]]; then
  source "$HOME/.zshenv_host"
fi

###############################################################################
export PATH="$HOME/dotfiles/utils:$PATH"
export PATH="$HOME/dotfiles/utils/wallpick:$PATH"
