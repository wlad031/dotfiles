function notes_setup() {
  export NOTES_DIR="$HOME/notes"
  export NOTES_JOURNALS_DIR="$NOTES_DIR/journals"
  export NOTES_PAGES_DIR="$NOTES_DIR/pages"
  export NOTES_TEMPLATES_DIR="$NOTES_DIR/templates"

  # How do I parse this?
  # id: {{date:YYYY-MM-DD}}

  function __nt_open_or_create_file() {
    if [[ -f "$1" ]]; then
      $EDITOR "$1"
    else
      if [[ ! -z "$2" ]]; then
        local template = "$2"
      fi
    fi
  }

  function __nt_journal_on_date() {
    local date="$1"
    local formatted_date
    if [[ -z "$date" ]]; then
      formatted_date=$(date +%Y_%m_%d)
    elif [[ $date == "today" || $date == "tod" ]]; then
      formatted_date=$(date +%Y_%m_%d)
    elif [[ $date =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
      formatted_date=$(date -d "$date" +%Y_%m_%d)
    elif [[ $date =~ ^[0-9]{4}_[0-9]{2}_[0-9]{2}$ ]]; then
      formatted_date="$date"
    elif [[ $date =~ ^[0-9]{4}.[0-9]{2}.[0-9]{2}$ ]]; then
      formatted_date=$(date -d "$date" +%Y_%m_%d)
    elif [[ $date =~ "^(\+|\-)[0-9]+$" ]]; then # offset
      formatted_date=$(date -d "$date days" +%Y_%m_%d)
    else
      log_error "Unknown date format: $date"
      return 1
    fi
    log_info "Opening journal for $formatted_date"
    $EDITOR "$NOTES_JOURNALS_DIR/$formatted_date.md"
  }

  function __nt() {
    local cmd="$1"
    shift
    if [[ -z "$cmd" ]]; then
      __nt_journal_on_date "today"
    else
      case "$cmd" in
        "journal") __nt_journal_on_date "$@";;
        *) log_error "Unknown command: $cmd"; return 1;;
      esac
    fi
  }

  alias nt="__nt"
}
