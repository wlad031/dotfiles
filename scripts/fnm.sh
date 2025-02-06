FNM_PATH="$HOME/.local/share/fnm"
FNM_COMMAND_INSTALLED=false
FNM_DIRECTORY_INSTALLED=false

if ! command -v fnm &> /dev/null; then
  FNM_COMMAND_INSTALLED=false
else
  FNM_COMMAND_INSTALLED=true
fi

if [[ "$FNM_COMMAND_INSTALLED" = false ]]; then
  if [[ -d "$FNM_PATH" ]]; then
    FNM_DIRECTORY_INSTALLED=true
  else
    FNM_DIRECTORY_INSTALLED=false
    export FNM_INSTALLED=false
  fi
fi

if [[ "$FNM_COMMAND_INSTALLED" = false && "$FNM_DIRECTORY_INSTALLED" = true ]]; then
  export PATH="$FNM_PATH:$PATH"
  export FNM_INSTALLED=true
fi

fnm_setup() {
  if [[ "$FNM_INSTALLED" = false ]]; then
    log_error "fnm (Node.js version manager) is not installed"
    return
  fi

  eval "$(fnm env --use-on-cd)"
}
