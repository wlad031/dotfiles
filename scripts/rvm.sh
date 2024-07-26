[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

if ! command -v rvm &> /dev/null; then
  export RVN_INSTALLED=false
else
  export RVM_INSTALLED=true
fi

rvm_setup() {
  if [[ "$RVM_INSTALLED" = false ]]; then
    log_error "rvm is not installed"
    return
  fi

  RVM_DIR="$HOME/.rvm"
  if [[ -d "$RVM_DIR" ]]; then
    export PATH="$PATH:$RVM_DIR/bin"
    eval "$(brew shellenv)"
  else
    log_error "Cannot find $RVM_DIR"
  fi
}
