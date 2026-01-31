###############################################################################
# Setting logging level
export LOG_INFO_ENABLED=true
export LOG_ERROR_ENABLED=true
export LOG_DEBUG_ENABLED=false
export WELCOME_SCREEN_ENABLED=false
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

add_to_path() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$PATH:$1" ;;
  esac
}

###############################################################################
# Common PATH changes
add_to_path "$HOME/.local/bin"
add_to_path "/usr/local/sbin"
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
add_to_path "$HOME/dotfiles/utils"
for d in $HOME/dotfiles/utils/*; do
  if [[ -d $d ]]; then
    add_to_path "$d"
  fi
done

export PATH

alias kubeconfig="source $HOME/dotfiles/utils/kubeconfig"
