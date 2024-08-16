if ! command -v aerospace &> /dev/null; then
  export AEROSPACE_INSTALLED=false
else
  export AEROSPACE_INSTALLED=true
fi

aerospace_setup() {
  local opt=$1
  if [[ "$AEROSPACE_INSTALLED" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "aerospace is not installed"
    else
      log_debug "aerospace is not installed"
    fi
    return
  fi

  __aerospace_change_env() {
    local gaps_file="$1"
    if [[ ! -f "$gaps_file" ]]; then
      log_error "Cannot find $gaps_file file"
      return
    fi

    local gaps=$(cat $gaps_file)
    
    dir="$DOTFILES_DIR/.config/aerospace"
    if [[ ! -d "$dir" ]]; then
      log_error "Cannot find aerospace config directory: $dir"
      return
    fi
    local config_file="$dir/aerospace.toml"
    local template_file="$dir/aerospace-template.toml"
    if [[ ! -f "$template_file" ]]; then
      log_error "Cannot find $template_file file"
      return
    fi

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

  function __aerospace() {
    local subcommand="$1"
    if [[ "$subcommand" == "env" ]]; then
      local env="$2"
      if [[ "$env" == "work" ]]; then
        __aerospace_change_env "$dir/gaps-work.toml"
      elif [[ "$env" == "home" ]]; then
        __aerospace_change_env "$dir/gaps-home.toml"
      else
        log_error "Unknown aerospace env: $2"
      fi
    else
      command aerospace "$@"
    fi
  }

  alias aerospace=__aerospace
}
