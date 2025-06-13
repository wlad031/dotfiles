command -v tldr &>/dev/null && export TLDR_INSTALLED=true || export TLDR_INSTALLED=false

tldr_setup() {
  local opt="${1:-optional}"
  if [[ "$TLDR_INSTALLED" = false ]]; then
    log_debug_or_error $opt "tldr is not installed"
    log_debug_or_error $opt "  Check: https://github.com/tealdeer-rs/tealdeer"
    return
  fi
}
