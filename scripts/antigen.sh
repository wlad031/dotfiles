doc=https://github.com/zsh-users/antigen
antigen_setup() {
  src="$HOME/.antigen.zsh"
  rc="$HOME/.antigenrc"
  if [[ -f "$src" ]]; then
    source "$src"
    if [[ -f "$rc" ]]; then
      antigen init "$rc"
      if grep -q "fzf-tab" "$rc"; then
        if ! command -v fzf >/dev/null; then
          log_error "Tab completion might be broken, fzf-tab is requested by $rc, but fzf is not installed"
        fi
      fi
    else
      log_error "Antigen isn't configured yet: couldn't find $rc"
    fi
  else
    log_error "Antigen isn't installed yet: couldn't find $src\n   $doc\n   Install with: curl -L git.io/antigen > .antigen.zsh"
  fi
}
