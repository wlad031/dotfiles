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
    # Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
    export PATH="$PATH:$RVM_DIR/bin"
    eval "$(brew shellenv)"
  else
    log_error "Cannot find $RVM_DIR"
  fi
}
