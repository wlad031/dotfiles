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

if [ -z "$ZSHRC_LOG_INFO"  ]; then export ZSHRC_LOG_INFO=true  ; fi
if [ -z "$ZSHRC_LOG_ERROR" ]; then export ZSHRC_LOG_ERROR=true ; fi
if [ -z "$ZSHRC_LOG_DEBUG" ]; then export ZSHRC_LOG_DEBUG=false; fi

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
    file=$1
    if [ -f $file ]; then
      source $file
      log_debug "Sourced env file: $file"
    else
      log_debug "Cannot source file: doesn't exist: $file"
    fi
}

read_env() {
    file=$1
    if [ -f $file ]; then
      export $(echo $(cat "$file" | sed 's/#.*//g'| xargs) | envsubst)
      log_debug "Loaded env file: $file"
    else
      log_debug "Cannot read env file: doesn't exist: $file"
    fi
}

setup_env() {
  cmd=$1
    if [[ "$cmd" == "git"     ]]; then git_setup
  elif [[ "$cmd" == "lazygit" ]]; then lazygit_setup
  elif [[ "$cmd" == "devmoji" ]]; then devmoji_setup
  elif [[ "$cmd" == "docker"  ]]; then docker_setup
  elif [[ "$cmd" == "tmux"    ]]; then tmux_setup
  elif [[ "$cmd" == "sesh"    ]]; then sesh_setup
  else log_error "Unknown thing to setup: $cmd"; fi
}

###############################################################################

###############################################################################
# Misc

bkp() {
    FILE=$1
    BKP="$FILE.bkp"
    echo "Copying $FILE to $BKP"
    cp $FILE $BKP
    echo "Backup file $FILE to $BKP"
}

###############################################################################

