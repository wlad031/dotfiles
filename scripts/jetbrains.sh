if [[ "$OSTYPE" == "darwin"* ]]; then
  export JETBRAINS_TOOLBOX_DIR="$HOME/Library/Application Support/JetBrains/Toolbox"
  if [[ -d "$JETBRAINS_TOOLBOX_DIR" ]]; then
    export JETBRAINS_TOOLBOX_INSTALLED=true
  else
    export JETBRAINS_TOOLBOX_INSTALLED=false
  fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  if ! command -v jetbrains-toolbox &> /dev/null; then
    export JETBRAINS_TOOLBOX_INSTALLED=false
  else
    export JETBRAINS_TOOLBOX_INSTALLED=true
  fi
else
  log_error "OSTYPE is not supported: $OSTYPE"
fi

jetbrains_setup() {
  if [[ "$JETBRAINS_TOOLBOX_INSTALLED" = false ]]; then
    log_error "JetBrains Toolbox is not installed"
    return
  fi

  if [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH="$JETBRAINS_TOOLBOX_DIR/scripts:$PATH"
  fi
}
