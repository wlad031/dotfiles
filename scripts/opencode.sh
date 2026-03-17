if ! command -v opencode &> /dev/null; then
  export OPENCODE_INSTALLED=false
else
  export OPENCODE_INSTALLED=true
fi


opencode_setup() {
  local opt=$1
  if [[ "$OPENCODE_INSTALLED" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "Opencode is not installed"
    else
      log_debug "Opencode is not installed"
    fi
    return
  fi

  REPO="git@gitea.local.vgerasimov.dev:wlad031/ai-agents.git"
  DIR="$HOME/.config/opencode/agents"

  __opencode_agents_init() {
    if [[ ! -d "$DIR" ]]; then
      git clone "$REPO" "$DIR"
    else
      log_warn "Agents directory already exists: $DIR"
    fi
  }

  __opencode_agents_pull() {
    if [[ ! -d "$DIR" ]]; then
      __opencode_agents_init
    else
      cd "$DIR"
      git pull
      cd -
    fi
  }

  __opencode_agents_push() {
    if [[ ! -d "$DIR" ]]; then
      log_error "Agents directory does not exist: $DIR"
      return 1
    else
      cd "$DIR"
      gitacp
    fi
  }

  __opencode_agents() {
    if [[ "$1" == "init" ]]; then
      shift
      __opencode_agents_init
    elif [[ "$1" == "pull" ]]; then
      shift
      __opencode_agents_pull
    elif [[ "$1" == "push" ]]; then
      shift
      __opencode_agents_push
    else
      log_error "Usage: opencode agents <init|pull|push>"
    fi
  }

  function __opencode() {
    if [[ "$1" == "agents" ]]; then
      shift
      __opencode_agents "$@"
    else
      command opencode "$@"
    fi
  }

  alias opencode=__opencode
}
