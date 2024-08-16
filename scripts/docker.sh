if ! command -v docker &> /dev/null; then
  export DOCKER_INSTALLED=false
else
  export DOCKER_INSTALLED=true
fi

docker_setup() {
  local opt=$1
  if [[ "$DOCKER_INSTALLED" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "docker is not installed"
    else
      log_debug "docker is not installed"
    fi
    return
  fi

  __docker_set_sock() {
    local sock=$1
    if [[ ! -e "$sock" ]]; then
      log_error "Socket not found: $sock"
      return
    fi
    export DOCKER_SOCK="$sock"
    export DOCKER_HOST="unix://$sock"
    log_debug "DOCKER_HOST: $DOCKER_HOST"
  }

  __docker_change_host() {
    local host=$1
    if [[ "$host" = "rancher" ]]; then
      __docker_change_host_rancher
    elif [[ "$host" = "colima" ]]; then
      __docker_change_host_colima "$2"
    else
      log_error "Unknown docker host: $host"
    fi
  }
  
  __docker_better_ps() {
    command docker ps --format 'table {{.Names}}\t{{.Status}} : {{.RunningFor}}\t{{.ID}}\t{{.Image}}' "$@"
  }

  __docker_better_psa() {
    command docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Size}}\n{{.ID}}\t{{.Image}}{{if .Ports}}{{with $p := split .Ports ", "}}\t{{len $p}} port(s) on {{end}}{{- .Networks}}{{else}}\tNo Ports on {{ .Networks }}{{end}}\n' "$@"
  }

  # docker ps with network information
  __docker_psnet() {
    command docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Networks}}\n{{.ID}}{{if .Ports}}{{with $p := split .Ports ", "}}{{range $p}}\t\t{{println .}}{{end}}{{end}}{{else}}\t\t{{println "No Ports"}}{{end}}' "$@"
  }

  function __docker() {
    if [[ "$1" == "ps" ]]; then
      shift
      __docker_better_ps "$@"
    elif [[ "$1" == "psa" ]]; then
      shift
      __docker_better_psa "$@"
    elif [[ "$1" == "psnet" ]]; then
      shift
      __docker_psnet "$@"
    elif [[ "$1" == "host" ]]; then
      shift
      __docker_change_host "$@"
    else
      command docker "$@"
    fi
  }

  alias docker=__docker

  __docker_get_default_host() {
    if [[ $RANCHER_INSTALLED = true ]]; then
      echo "rancher"
    elif [[ $COLIMA_INSTALLED = true ]]; then
      echo "colima"
    fi
  }

  __docker_set_default_host() {
    local default_host=$(__docker_get_default_host)
    if [[ -z "$default_host" ]]; then
      log_error "Could not find default docker host"
      return
    fi

    log_debug "Setting docker host to $default_host"
    __docker host "$default_host"
  }

  __docker_set_default_host
}
