###############################################################################
# Setting logging level
export ZSHRC_LOG_INFO=true
export ZSHRC_LOG_ERROR=true
export ZSHRC_LOG_DEBUG=false
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
utils_file="$HOME/utils.sh"
if [ -f "$utils_file" ]; then
  source "$utils_file"
else
  echo "Cannot find $utils_file file"
  return
fi
###############################################################################

export WELCOME_SCREEN_ENABLED=false

###############################################################################
# Exporting other env files
read_env    "$HOME/.env"
source_safe "$HOME/scripts/zshrc_antigen.sh"
source_safe "$HOME/.cargo/env"
source_safe "$HOME/.g/env"
source_safe "$HOME/scripts/zshrc_ohmyposh.sh"
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
source_safe "$HOME/scripts/zshrc_codium.sh"
source_safe "$HOME/scripts/zshrc_fnm.sh"
source_safe "$HOME/scripts/zshrc_flutter.sh"
source_safe "$HOME/scripts/zshrc_pyenv.sh"
source_safe "$HOME/scripts/zshrc_gcloud.sh"
source_safe "$HOME/scripts/zshrc_rvm.sh"
source_safe "$HOME/scripts/zshrc_coursier.sh"
source_safe "$HOME/scripts/zshrc_thefuck.sh"
source_safe "$HOME/scripts/zshrc_fastfetch.sh"
source_safe "$HOME/scripts/zshrc_zoxide.sh"
source_safe "$HOME/.sdkman/bin/sdkman-init.sh"
###############################################################################

# TODO: Export true/false variables indicating this or that program is installed.
# TODO: Separate files for each program.

