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


# This variable is automatically inserted by the installer of ask.sh
export ASK_SH_OPENAI_API_KEY=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

# This line is automatically inserted by the installer of ask.sh
if command -v ask-sh >/dev/null 2>&1; then
  eval "$(ask-sh --init)"
fi
