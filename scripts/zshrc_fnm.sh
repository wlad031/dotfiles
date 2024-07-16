if ! command -v fnm &> /dev/null; then
  export FNM_INSTALLED=false
else
  export FNM_INSTALLED=true
fi

fnm_setup() {
  if [[ "$FNM_INSTALLED" = false ]]; then
    log_error "fnm (Node.js version manager) is not installed"
    return
  fi
    
  eval "$(fnm env --use-on-cd)"
}
