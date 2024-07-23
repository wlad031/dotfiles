
if ! command -v pyenv &> /dev/null; then
  export PYENV_INSTALLED=false
else
  export PYENV_INSTALLED=true
fi

pyenv_setup() {
  if [[ "$PYENV_INSTALLED" = false ]]; then
    log_error "pyenv (Python version manager) is not installed"
    return
  fi

  export PYENV_ROOT="$HOME/.pyenv"
  [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  export PIPX_DEFAULT_PYTHON="$PYENV_ROOT/versions/3.12.2/bin/python"
}
