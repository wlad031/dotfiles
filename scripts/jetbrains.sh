export JETBRAINS_TOOLBOX_DIR="$HOME/Library/Application Support/JetBrains/Toolbox"
if [[ -d "$JETBRAINS_TOOLBOX_DIR" ]]; then
  export JETBRAINS_TOOLBOX_INSTALLED=true
else
  export JETBRAINS_TOOLBOX_INSTALLED=false
fi

jetbrains_setup() {
  if [[ "$JETBRAINS_TOOLBOX_INSTALLED" = false ]]; then
    log_error "JetBrains Toolbox is not installed"
    return
  fi

  export PATH="$JETBRAINS_TOOLBOX_DIR/scripts:$PATH"
}
