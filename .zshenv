###############################################################################
# Setting logging level
export ZSHRC_LOG_INFO=true
export ZSHRC_LOG_ERROR=true
export ZSHRC_LOG_DEBUG=false
export WELCOME_SCREEN_ENABLED=true
###############################################################################

###############################################################################
# Common variables
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
# Common aliases
alias xx='exit'
alias ll="ls -la"
###############################################################################

###############################################################################
# Including common utilities
local utils_file="$HOME/utils.sh"
if [[ -f "$utils_file" ]]; then
  source "$utils_file"
else
  echo "Cannot find $utils_file file"
  return
fi
###############################################################################

###############################################################################
# Homebrew
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  log_debug "Found Homebrew at /opt/homebrew/bin/brew"
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
  log_debug "Found Homebrew at /usr/local/bin/brew"
  eval "$(/usr/local/bin/brew shellenv)"
else
  log_error "Cannot find brew installation"
  return
fi

###############################################################################

###############################################################################
# Sourcing other env files
read_env    "$HOME/.env"
source_safe "$HOME/scripts/antigen.sh"
source_safe "$HOME/scripts/ohmyposh.sh"
source_safe "$HOME/scripts/git.sh"
source_safe "$HOME/scripts/eza.sh"
source_safe "$HOME/scripts/bat.sh"
source_safe "$HOME/scripts/tmux.sh"
source_safe "$HOME/scripts/docker.sh"
source_safe "$HOME/scripts/sesh.sh"
source_safe "$HOME/scripts/fzf.sh"
source_safe "$HOME/scripts/lazygit.sh"
source_safe "$HOME/scripts/devmoji.sh"
source_safe "$HOME/scripts/neovim.sh"
source_safe "$HOME/scripts/codium.sh"
source_safe "$HOME/scripts/fnm.sh"
source_safe "$HOME/scripts/flutter.sh"
source_safe "$HOME/scripts/g.sh"
source_safe "$HOME/scripts/sdkman.sh"
source_safe "$HOME/scripts/pyenv.sh"
source_safe "$HOME/scripts/gcloud.sh"
source_safe "$HOME/scripts/rvm.sh"
source_safe "$HOME/scripts/cargo.sh"
source_safe "$HOME/scripts/coursier.sh"
source_safe "$HOME/scripts/thefuck.sh"
source_safe "$HOME/scripts/fastfetch.sh"
source_safe "$HOME/scripts/zoxide.sh"
source_safe "$HOME/scripts/yazi.sh"
source_safe "$HOME/scripts/jetbrains.sh"
###############################################################################

