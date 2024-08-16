###############################################################################
# Color printing

CL_RED='\033[0;31m'
CL_BLUE='\033[0;34m'
CL_PURPLE='\033[0;35m'
CL_NO='\033[0m'

echo_cl() { clr=$1; str=$2; echo -e "$clr$str$CL_NO"; }
echo_cl_red   () { echo_cl $CL_RED $*    }
echo_cl_blue  () { echo_cl $CL_BLUE $*   }
echo_cl_purple() { echo_cl $CL_PURPLE $* }

###############################################################################

###############################################################################
# Logging

# TODO: Find some better way to do logging
# TODO: Remove ZSH_* prefix

if [[ -z "$ZSHRC_LOG_INFO"  ]]; then export ZSHRC_LOG_INFO=true  ; fi
if [[ -z "$ZSHRC_LOG_ERROR" ]]; then export ZSHRC_LOG_ERROR=true ; fi
if [[ -z "$ZSHRC_LOG_DEBUG" ]]; then export ZSHRC_LOG_DEBUG=false; fi

log_info() {
  if "$ZSHRC_LOG_INFO" || "$ZSHRC_LOG_ERROR" || "$ZSHRC_LOG_DEBUG"; then
    echo -e "$(echo_cl_blue "[INFO ]") $*"
  fi
}

log_error() {
  if "$ZSHRC_LOG_ERROR" || "$ZSHRC_LOG_DEBUG"; then
    echo -e "$(echo_cl_red "[ERROR]") $*"
  fi
}

log_debug() {
  if "$ZSHRC_LOG_DEBUG"; then
    echo -e "$(echo_cl_purple "[DEBUG]") $*"
  fi
}

###############################################################################

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

