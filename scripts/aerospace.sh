if ! command -v aerospace &> /dev/null; then
  export AEROSPACE_INSTALLED=false
else
  export AEROSPACE_INSTALLED=true
fi

aerospace_setup() {
  if [[ "$AEROSPACE_INSTALLED" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "aerospace is not installed"
    else
      log_debug "aerospace is not installed"
    fi
    return
  fi

  dir="$HOME/dotfiles/.config/aerospace"

  aerospace_env() {
    local gaps_file="$1"
    local gaps=$(cat $gaps_file)
    
    local config_file="$dir/aerospace.toml"
    local template_file="$dir/aerospace-template.toml"

    replace_placeholders "$template_file" \
       "gaps" $gaps                       \
       > "$config_file"

    log_info "Updated $config_file with:"
    echo ""
    log_info "Gaps:"
    echo "$gaps"
    echo ""

    aerospace reload-config
    log_info "Reloaded aerospace"
  }

  aerospace_home() {
    aerospace_env "$dir/gaps-home.toml"
  }

  aerospace_work() {
    aerospace_env "$dir/gaps-work.toml"
  }
}
