###############################################################################
# Color printing

CL_RED='\033[0;31m'
CL_BLUE='\033[0;34m'
CL_PURPLE='\033[0;35m'
CL_YELLOW='\033[0;33m'
CL_NO='\033[0m'

echo_cl       () { clr="$1"; str="$2"; echo -e "${clr}${str}${CL_NO}"; }
echo_cl_blue  () { echo_cl "$CL_BLUE"   "$*"; }
echo_cl_red   () { echo_cl "$CL_RED"    "$*"; }
echo_cl_purple() { echo_cl "$CL_PURPLE" "$*"; }
echo_cl_yellow() { echo_cl "$CL_YELLOW" "$*"; }

###############################################################################

###############################################################################
# Logging

# TODO: Find some better way to do logging

if [[ -z "$LOG_INFO_ENABLED"  ]]; then export LOG_INFO_ENABLED=true  ; fi
if [[ -z "$LOG_WARN_ENABLED"  ]]; then export LOG_WARN_ENABLED=true  ; fi
if [[ -z "$LOG_ERROR_ENABLED" ]]; then export LOG_ERROR_ENABLED=true ; fi
if [[ -z "$LOG_DEBUG_ENABLED" ]]; then export LOG_DEBUG_ENABLED=false; fi

log_info() {
  if "$LOG_INFO_ENABLED" || "$LOG_WARN_ENABLED" || "$LOG_ERROR_ENABLED" || "$LOG_DEBUG_ENABLED"; then
    echo -e "$(echo_cl_blue "[INFO ]") $*"
  fi
}

log_warn() {
  if "$LOG_WARN_ENABLED" || "$LOG_ERROR_ENABLED" || "$LOG_DEBUG_ENABLED"; then
    echo -e "$(echo_cl_yellow "[WARN ]") $*"
  fi
}

log_error() {
  if "$LOG_ERROR_ENABLED" || "$LOG_DEBUG_ENABLED"; then
    echo -e "$(echo_cl_red "[ERROR]") $*"
  fi
}

log_debug() {
  if "$LOG_DEBUG_ENABLED"; then
    echo -e "$(echo_cl_purple "[DEBUG]") $*"
  fi
}

log_debug_or_error() {
  local opt="$1"
  shift
  if [[ $opt == "required" ]]; then
    log_error "$*"
  else
    log_debug "$*"
  fi
}

###############################################################################
