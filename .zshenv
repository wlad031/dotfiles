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
alias zz='exit'
alias ll="ls -la"
###############################################################################

###############################################################################
# ZSH History
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt SHARE_HISTORY
###############################################################################

###############################################################################
# Including common utilities
export DOTFILES_DIR="$HOME/dotfiles"
if [[ ! -d "$DOTFILES_DIR" ]]; then
  echo "Cannot find dotfiles: $DOTFILES_DIR"
  return
fi
export DOTFILES_SCRIPTS_DIR="$DOTFILES_DIR/scripts"
if [[ ! -d "$DOTFILES_SCRIPTS_DIR" ]]; then
  echo "Cannot find dotfiles scripts: $DOTFILES_SCRIPTS_DIR"
  return
fi
export DOTFILES_SCRIPTS_COMMON_UTILITIES="$DOTFILES_SCRIPTS_DIR/common.sh"
if [[ ! -f "$DOTFILES_SCRIPTS_COMMON_UTILITIES" ]]; then
  echo "Cannot find common utilities: $DOTFILES_SCRIPTS_COMMON_UTILITIES"
  return
fi
source "$DOTFILES_SCRIPTS_COMMON_UTILITIES"
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

source_safe "$DOTFILES_SCRIPTS_DIR/cargo.sh"
cargo_setup

###############################################################################

###############################################################################
# Sourcing other env files
read_env    "$HOME/.env"
source_safe "$DOTFILES_SCRIPTS_DIR/antigen.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/ohmyposh.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/git.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/eza.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/bat.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/tmux.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/colima.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/rancher.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/docker.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/lazydocker.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/sesh.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/fzf.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/lazygit.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/devmoji.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/neovim.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/codium.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/fnm.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/flutter.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/g.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/sdkman.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/pyenv.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/gcloud.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/rvm.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/coursier.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/thefuck.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/fastfetch.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/zoxide.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/yazi.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/jetbrains.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/luaver.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/xcmd.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/atuin.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/sshs.sh"
source_safe "$DOTFILES_SCRIPTS_DIR/aerospace.sh"
###############################################################################

