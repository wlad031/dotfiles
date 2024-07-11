# TODO: Refactor this one

docker_setup() {
# Colima
is_colima_installed=false
COLIMA_DIR="$HOME/.colima"
if ! command -v colima &> /dev/null
then
  is_colima_installed=false else is_colima_installed=true
fi

# Rancher Desktop
is_rancher_installed=false
RANCHER_DIR="$HOME/.rd"
if [[ -d "$RANCHER_DIR" ]]; then
  export PATH="$PATH:$RANCHER_DIR/bin"
  is_rancher_installed=true
else
  is_rancher_installed=false
fi

# Common
if ! command -v docker &> /dev/null
then
  log_error "Docker is not installed"
else
  local default_host
  if [[ "$is_colima_installed" = false && "$is_colima_installed" = false ]]; then
    log_error "None of [colima, rancher] is installed"
  elif [[ "$is_rancher_installed" = true ]]; then
    default_host="rancher"
  elif [[ "$is_colima_installed" = true ]]; then
    default_host="colima"
  fi

  function dock() {
    if [[ "$@" == "ps" ]]; then
      command docker ps --format 'table {{.Names}}\t{{.Status}} : {{.RunningFor}}\t{{.ID}}\t{{.Image}}'
    elif [[ "$@" == "psa" ]]; then
      # docker ps -a includes all containers
      command docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Size}}\n{{.ID}}\t{{.Image}}{{if .Ports}}{{with $p := split .Ports ", "}}\t{{len $p}} port(s) on {{end}}{{- .Networks}}{{else}}\tNo Ports on {{ .Networks }}{{end}}\n'
    elif [[ "$@" == "psnet" ]]; then
      # docker ps with network information
      command docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Networks}}\n{{.ID}}{{if .Ports}}{{with $p := split .Ports ", "}}{{range $p}}\t\t{{println .}}{{end}}{{end}}{{else}}\t\t{{println "No Ports"}}{{end}}'
    elif [[ "$1" == "host" ]]; then # TODO: Extract this as a separate function, at least
      if [[ "$2" == "rancher" ]]; then
        if [ "$is_rancher_installed" = true ]; then
          docker_sock="$RANCHER_DIR/docker.sock"
          if [ -e "$docker_sock" ]; then
            export DOCKER_HOST="unix://$docker_sock"
            echo "Docker environment updated"
          else
            log_error "$docker_sock not found"
          fi
        else
          log_error "Rancher is not installed"
        fi
      elif [[ "$2" == "colima" ]]; then
        if [ "$is_colima_installed" = true ]; then
          docker_sock="$COLIMA_DIR/${3:-default}/docker.sock"
          if [ -e "$docker_sock" ]; then
            export DOCKER_HOST="unix://$docker_sock"
            echo "Docker environment updated"
          else
            log_error "$docker_sock not found"
          fi
        else
          log_error "Colima is not installed"
        fi
      elif [[ ! -z "$2" ]]; then
        log_error "Unknown docker host: $2"
      fi
      echo "DOCKER_HOST: $DOCKER_HOST"
    else
      command docker "$@"
    fi
  }

  if [[ "$default_host" == "rancher" ]]; then
    log_debug "Setting rancher as Docker host"
    dock host rancher > /dev/null
  elif [[ "$default_host" == "colima" ]]; then
    log_debug "Setting colima default as Docker host"
    dock host colima > /dev/null
  fi

  if ! command -v lazydocker &> /dev/null
  then
    log_error "Lazydocker is not installed"
  else
    alias ldocker=lazydocker
  fi
fi
}
