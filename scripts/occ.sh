NEXTCLOUD_CONTAINER=nextcloud

if [[ "$DOCKER_INSTALLED" = false ]]; then
  if docker inspect $NEXTCLOUD_CONTAINER &>/dev/null; then
    export OCC_INSTALLED=true
  else
    export OCC_INSTALLED=false
  fi
else
  export OCC_INSTALLED=false
fi

occ_setup() {

  function __occ_command() {
    docker exec -ti -u 33 $NEXTCLOUD_CONTAINER bash -c "./occ $@"
  }

  function __occ_scan() {
    if [[ "$1" == "all" ]]; then
      __occ_command "files:scan --all"
    else
      __occ_command "files:scan $@"
    fi
  }

  function __occ() {
      if [[ "$1" == "scan" ]]; then
        shift
        __occ_scan "$@"
      else
        __occ_command "$@"
      fi
  }

  alias occ=__occ
}

