dotfiles_module_key() {
  local name="$1"
  local key
  key=$(printf '%s' "$name" | tr '[:lower:]' '[:upper:]')
  key=$(printf '%s' "$key" | tr -c 'A-Z0-9' '_')
  key=${key##_}
  key=${key%%_}
  printf '%s' "$key"
}

dotfiles_module_export() {
  local name="$1"
  local module_status="$2"
  local prefix="${DOTFILES_MODULE_PREFIX:-DOTFILES_MODULE_}"
  local key
  key=$(dotfiles_module_key "$name")
  export "${prefix}${key}=${module_status}"
}

dotfiles_module_load() {
  local name="$1"
  local setup_fn="${2:-}"

  if [[ -n "$setup_fn" ]] && typeset -f "$setup_fn" >/dev/null 2>&1; then
    dotfiles_module_export "$name" 1
    "$setup_fn"
  else
    dotfiles_module_export "$name" 0
  fi
}

dotfiles_module_load_all() {
  local scripts_dir="${DOTFILES_SCRIPTS_DIR:-$HOME/dotfiles/scripts}"
  local config="${1:-${DOTFILES_SYSREADY_CONFIG:-$scripts_dir/../sysready.yaml}}"
  local all_file="$scripts_dir/all.sh"
  local tool_count i
  local script setup name

  if [[ -f "$all_file" ]]; then
    # shellcheck disable=SC1090
    source "$all_file"
  fi

  if [[ ! -f "$config" ]]; then
    return 0
  fi

  if ! command -v yq >/dev/null 2>&1; then
    printf '%s\n' "dotfiles_module_load_all: yq not found" >&2
    return 0
  fi

  if ! yq -e '.tools' "$config" >/dev/null 2>&1; then
    return 0
  fi

  while IFS= read -r line; do
    [[ -z "$line" ]] && continue

    setup=${line%%$'\t'*}
    rest=${line#*$'\t'}
    load_name=${rest%%$'\t'*}
    base_name=${rest#*$'\t'}

    name="$load_name"
    if [[ -z "$name" ]]; then
      name="$base_name"
    fi
    if [[ -z "$setup" ]]; then
      setup="${name}_setup"
    fi

    dotfiles_module_load "$name" "$setup"
  done < <(
    yq -r '.tools[] | select(.load) | [
      (if (.load|type) == "object" then (.load.setup // "") else "" end),
      (if (.load|type) == "object" then (.load.name // "") else "" end),
      (.name // "")
    ] | @tsv' "$config" 2>/dev/null
  )
}
