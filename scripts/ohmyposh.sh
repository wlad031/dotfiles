if ! command -v oh-my-posh &> /dev/null; then
  export OHMYPOSH_INSTALLED=false
else
  export OHMYPOSH_INSTALLED=true
fi

ohmyposh_setup() {
  doc=https://ohmyposh.dev/docs/installation/
  local opt=$1
  if [[ "$OHMYPOSH_INSTALLED" = false ]]; then
    function log() {
      if [[ "$opt" = "required" ]]; then
        log_error "$*"
      else
        log_debug "$*"
      fi
    }
    log "oh-my-posh is not installed\n    $doc\n   Install with: curl -s https://ohmyposh.dev/install.sh | bash -s"
    return
  fi
  if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
    eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/themes/zen.toml)"
  fi
}
