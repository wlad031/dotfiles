export EDITOR='vim'
export LC_ALL=en_US.UTF-8

# TODO: do all aliases in the same place
alias xx="exit"

# TODO: correct working with python and pyenv
export PATH="/usr/local/opt/python@2/libexec/bin:$PATH"

export EMACSD_DIR="$HOME/.emacs.d/"

# TODO: use simplified syntax
if [ -f "$HOME/.load_sdkman.sh" ]; then source "$HOME/.load_sdkman.sh"; fi
if [ -f "$HOME/.load_gcsdk.sh" ]; then source "$HOME/.load_gcsdk.sh"; fi
if [ -f "$HOME/.load_nvm.sh" ]; then source "$HOME/.load_nvm.sh"; fi
if [ -f "$HOME/.load_pyenv.sh" ]; then source "$HOME/.load_pyenv.sh"; fi
if [ -f "$HOME/.load_go.sh" ]; then source "$HOME/.load_go.sh"; fi
if [ -f "$HOME/.load_ignite.sh" ]; then source "$HOME/.load_ignite.sh"; fi

export PATH="/usr/local/sbin:$PATH"

# TODO: do I really need this?
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# TODO: segragate antigen using into speciefic file
source ~/.antigen.zsh

antigen use oh-my-zsh

antigen bundle git
#antigen bundle heroku
antigen bundle pip
#antigen bundle lein
#antigen bundle command-not-found
antigen bundle docker
antigen bundle 'wfxr/forgit'
antigen bundle kazhala/dotbare

antigen bundle zsh-users/zsh-syntax-highlighting

antigen theme robbyrussell

antigen apply

alias ll="ls -lah"

alias emacs="/Applications/Emacs.app/Contents/MacOS/Emacs -nw"
