antigen_setup() {
  if [ -f "$HOME/.antigen.zsh" ]; then
    source "$HOME/.antigen.zsh"
    antigen init "$HOME/.antigenrc"
  else
    log_error "Antigen isn't installed yet"
  fi
}
