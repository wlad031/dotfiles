#!/bin/zsh

declare -A CONFIG
CONFIG["directory"]="eza --tree --color=always {path} | head -200"
CONFIG["text/plain"]="bat -n --color=always --line-range :500 {path}"
CONFIG["image/png"]="kitty +kitten icat --use-window-size 30,30,300,200 {path}"
CONFIG["application/pdf"]="pdftotext {path} - | head -n 50"
CONFIG["text/html"]="w3m -dump {path}"
CONFIG["audio"]="ffplay -nodisp -autoexit {path}"
CONFIG["video"]="ffplay -autoexit {path}"

get_mime_type() {
  local file_path=$1
  if [[ -d "$file_path" ]]; then
    echo "directory"
  else
    file --mime-type -b "$1"
  fi
}

get_command() {
  local mime_type=$1
  local cmd="${CONFIG["$mime_type"]}"
  if [[ -z "$cmd" ]]; then
      cmd="echo 'No preview available for this file type: $mime_type'"
  fi
  echo "$cmd"
}

file_path="$1"
mime_type=$(get_mime_type "$file_path")
command=$(get_command "$mime_type")
command=${command//\{path\}/$file_path}
eval "$command"

