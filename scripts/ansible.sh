if ! command -v ansible &> /dev/null; then
  export ANSIBLE_INSTALLED=false
else
  export ANSIBLE_INSTALLED=true
fi

ansible_setup() {
  local opt=$1
  if [[ "$ANSIBLE_INSTALLED" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "ansible is not installed"
    else
      log_debug "ansible is not installed"
    fi
    return
  fi

  export ANSIBLE_DEFAULT_PRIVATE_KEY_FILE="$HOME/.ssh/homelab_cicd_rsa"

  function __vault_edit() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
      file="vault.yml"
    fi
    ansible-vault edit "$file"
  }

  function __playbook() {
    local playbook="$1"
    shift
    local args="$@"
    ansible-playbook "$playbook" --private-key="$ANSIBLE_DEFAULT_PRIVATE_KEY_FILE" "$args"
  }

  alias ave="__vault_edit"
  alias apb="__playbook"
}
