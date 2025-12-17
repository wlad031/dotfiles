if ! command -v tenv &> /dev/null; then
  export TENV_INSTALLED=false
else
  export TENV_INSTALLED=true
fi

tenv_setup() {
  local opt="$1"
  if [[ "$TENV_INSTALLED" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "tenv is not installed"
    else
      log_debug "tenv is not installed"
    fi
    return
  fi
  if [[ ! -f "$HOME/.tenv.completion.zsh" ]]; then
    tenv completion zsh > $HOME/.tenv.completion.zsh
  fi
  source_safe "$HOME/.tenv.completion.zsh"
}
