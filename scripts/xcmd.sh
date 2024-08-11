if [[ -d "$HOME/.x-cmd.root" ]]; then
  export XCMD_INSTALLED=true
else
  export XCMD_INSTALLED=false
fi

xcmd_setup() {
  if [[ "$XCMD_INSTALLED" = false ]]; then
    log_error "x-cmd is not installed"
    return
  fi

  source_safe "$HOME/.x-cmd.root/X"
}
