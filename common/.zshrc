x="bash/lib/common.sh"; f="$HOME/dotfiles/$x"; [ -f $f ] || f="$HOME/.cache/dotfiles/$x" && [ -f $f ] || (mkdir -p ${f%/*} && wget -qO $f "https://raw.githubusercontent.com/wlad031/dotfiles/refs/heads/master/$x"); source $f

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

