if [[ -d "$HOME/.luaver" ]]; then
  export LUAVER_INSTALLED=true
else
  export LUAVER_INSTALLED=false
fi

luaver_setup() {
  local opt=$1
  if [[ "$LUAVER_INSTALLED" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "luaver (Lua version manager) is not installed"
    else
      log_debug "luaver (Lua version manager) is not installed"
    fi
    return
  fi

  source_safe "$HOME/.luaver/luaver" > /dev/null
}
