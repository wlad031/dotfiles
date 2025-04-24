f="$HOME/.cache/dotfiles/common.sh"; [ -f "$f" ] || (mkdir -p "${f%/*}" && wget -qO "$f" https://gitea.local.vgerasimov.dev/wlad031/dotfiles/raw/branch/master/common.sh); source "$f"

###############################################################################
# Common aliases
alias xx='exit'
alias zz='exit'
alias ll="ls -la"
# be paranoid
alias cp='cp -ip'
alias mv='mv -i'
alias rm='rm -i'
###############################################################################

source_safe "$HOME/.zshrc_host"
# source_safe "$HOME/.zshrc_user"

