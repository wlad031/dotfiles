###############################################################################
# Setting logging level
export ZSHRC_LOG_INFO=true
export ZSHRC_LOG_ERROR=true
export ZSHRC_LOG_DEBUG=true
###############################################################################

###############################################################################
# Common variables
export UID=$(id -u)
export GID=$(id -g)
export EDITOR='vim'
export LC_ALL=en_US.UTF-8
###############################################################################

###############################################################################
# Common aliases
alias xx='exit'
alias ll="ls -la"
###############################################################################

###############################################################################
# Including common utilities
utils_file="$HOME/utils.sh"
if [ -f "$utils_file" ]; then
  source "$utils_file"
else
  echo "Cannot find $utils_file file"
  return
fi
###############################################################################

###############################################################################
# Exporting other env files
read_env    "$HOME/.env"
source_safe "$HOME/.cargo/env"
source_safe "$HOME/.g/env"
source_safe "$HOME/scripts/zshrc_git.sh"
source_safe "$HOME/scripts/zshrc_eza.sh"
source_safe "$HOME/scripts/zshrc_bat.sh"
source_safe "$HOME/scripts/zshrc_tmux.sh"
source_safe "$HOME/scripts/zshrc_docker.sh"
source_safe "$HOME/scripts/zshrc_sesh.sh"
source_safe "$HOME/scripts/zshrc_fzf.sh"
source_safe "$HOME/scripts/zshrc_lazygit.sh"
source_safe "$HOME/scripts/zshrc_devmoji.sh"
source_safe "$HOME/scripts/zshrc_neovim.sh"
source_safe "$HOME/.sdkman/bin/sdkman-init.sh"
###############################################################################

# TODO: Export true/false variables indicating this or that program is installed.
# TODO: Separate files for each program.

