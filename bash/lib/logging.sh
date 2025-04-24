###############################################################################
# Color printing

CL_RED='\033[0;31m'
CL_BLUE='\033[0;34m'
CL_PURPLE='\033[0;35m'
CL_NO='\033[0m'

echo_cl       () { clr="$1"; str="$2"; echo -e "${clr}${str}${CL_NO}"; }
echo_cl_blue  () { echo_cl "$CL_BLUE"   "$*"; }
echo_cl_red   () { echo_cl "$CL_RED"    "$*"; }
echo_cl_purple() { echo_cl "$CL_PURPLE" "$*"; }

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
