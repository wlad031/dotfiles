# Uncomment for profiling this script
# zmodload zsh/zprof

export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.jetbrains:$PATH"

if [ -f "$HOME/.antigen.zsh" ]; then
    source "$HOME/.antigen.zsh"
    antigen init "$HOME/.antigenrc"
else
    log_error "Antigen isn't installed yet"
fi


git_setup
lazygit_setup
devmoji_setup
docker_setup
tmux_setup
sesh_setup
fzf_setup
bat_setup
eza_setup
neovim_setup

export PATH="$HOME/go/bin:$PATH"

#GO_DIR="$HOME/.go"
#if [[ -d "$GO_DIR" ]]
#then
#    export GOROOT="$GO_DIR/current"
#    export GOPATH="$GO_DIR"
#    export PATH="$GOROOT:$PATH"
#fi

FLUTTER_DIR="$HOME/.flutter"
if [[ -d "$FLUTTER_DIR" ]]
then
    export FLUTTERPATH="$FLUTTER_DIR"
    export PATH="$FLUTTERPATH/bin:$PATH"
fi

if ! command -v nvim &> /dev/null
then
  log_error "Neovim is not installed"
else
    alias vim="nvim"
fi

if ! command -v codium &> /dev/null
then
  log_error "VSCodium is not installed"
else
    alias code="codium"
fi


if ! command -v bat &> /dev/null
then
  log_error "Bat is not installed"
else
    alias cat="bat"
fi


if ! command -v fnm &> /dev/null
then
  log_error "fnm (Node.js version manager) is not installed"
else
    eval "$(fnm env --use-on-cd)"
fi

if ! command -v pyenv &> /dev/null
then
  log_error "pyenv (Python version manager) is not installed"
else
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    export PIPX_DEFAULT_PYTHON="$PYENV_ROOT/versions/3.12.2/bin/python"
fi


if [ -f "$HOME/apps/google-cloud-sdk/path.zsh.inc" ];
then
    . "$HOME/apps/google-cloud-sdk/path.zsh.inc";
fi

if [ -f "$HOME/apps/google-cloud-sdk/completion.zsh.inc" ];
then
    . "$HOME/apps/google-cloud-sdk/completion.zsh.inc";
fi

RVM_DIR="$HOME/.rvm"
if [[ -d "$RVM_DIR" ]]
then
    # Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
    export PATH="$PATH:$RVM_DIR/bin"
    eval "$(brew shellenv)"
fi

if ! command -v coursier &> /dev/null
then
  log_error "Coursier is not installed"
else
  COURSIER_DIR="$HOME/Library/Application Support/Coursier"
  if [[ -d "$COURSIER_DIR" ]]
  then
    export PATH="$PATH:$COURSIER_DIR/bin"
  else
    log_error "Coursier installed in an unknown directory"
  fi
fi

if ! command -v thefuck &> /dev/null
then
  log_debug "the fuck is not installed"
else
  eval $(thefuck --alias)
fi

export LOGSEQ_DIR="$HOME/Logseq"
export LEDGER_DIR="$HOME/ledger"
export LEDGER_FILE="$LEDGER_DIR/2024.hledger"

###############################################################################
# fastfetch

if ! command -v fastfetch &> /dev/null
then
  log_debug "fastfetch is not installed"
else
  # TODO: Make this configurable
  # fastfetch
fi
###############################################################################

###############################################################################
# Oh My Posh
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/themes/zen.toml)"
fi
###############################################################################

###############################################################################
# zoxide
eval "$(zoxide init zsh)"
###############################################################################

###############################################################################

# Uncomment for profiling this script
# zprof


### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/vgerasimov/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
