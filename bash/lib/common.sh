f="$HOME/.cache/bash/logging.sh"; [ -f "$f" ] || (mkdir -p "${f%/*}" && wget -qO "$f" https://gitea.local.vgerasimov.dev/wlad031/dotfiles/raw/branch/master/bash/lib/logging.sh); source "$f"

###############################################################################
# Environment loading

source_safe() {
  local file=$1
  if [[ -f $file ]]; then
    source $file
    log_debug "Sourced env file: $file"
  else
    log_error "Cannot source file: doesn't exist: $file"
  fi
}

read_env() {
  local file=$1
  if ! command -v envsubst > /dev/null 2>&1; then
      log_error "envsubst command is not found, cannot read key-value 'env' files"
      return
  fi

  if [[ -f $file ]]; then
    export $(echo $(cat "$file" | sed 's/#.*//g'| xargs) | envsubst)
    log_debug "Loaded env file: $file"
  else
    log_error "Cannot read env file: doesn't exist: $file"
  fi
}

squash_app_rc() {
  local dir=$1

  if [[ ! -d "$dir" ]]; then
    echo "Directory $dir does not exist"
    return 1
  fi

  # Find files matching the pattern *rc, sort them, and concatenate their contents
  find "$dir" -type f -name '*rc_*.sh' | sort | while read -r file; do
      cat "$file"
  done
}

###############################################################################

###############################################################################
# Misc

path() {
    echo "$PATH" | tr ":" "\n" | nl
}

bkp() {
  local FILE=$1
  local BKP="$FILE.bkp"
  echo "Copying $FILE to $BKP"
  cp $FILE $BKP
  echo "Backup file $FILE to $BKP"
}

replace_placeholders() {
  local file="$1"
  shift

  local content=$(<"$file")

  while [[ $# -gt 0 ]]; do
    placeholder="$1"
    value="$2"
    content="${content//\{\{$placeholder\}\}/$value}"
    shift 2
  done

  echo "$content"
}

###############################################################################

