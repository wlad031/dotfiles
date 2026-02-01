#!/usr/bin/env bash
set -euo pipefail

WALL_DIR="${WALL_DIR:-$HOME/Pictures/wallpapers}"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/rofi-wallpapers"
THUMB_SIZE="${THUMB_SIZE:-320}"   # thumbnail square size in px
BACKEND="${BACKEND:-awww}"

mkdir -p "$CACHE_DIR"

thumb_for() {
  local f="$1"
  local key thumb
  key="$(printf '%s' "$f" | sha1sum | awk '{print $1}')"
  thumb="$CACHE_DIR/$key.png"

  if [[ ! -f "$thumb" ]]; then
    magick "$f" -auto-orient -thumbnail "${THUMB_SIZE}x${THUMB_SIZE}^" \
      -gravity center -extent "${THUMB_SIZE}x${THUMB_SIZE}" \
      -strip "$thumb" 2>/dev/null || true
  fi

  printf '%s' "$thumb"
}

apply_wallpaper() {
  local selected="$1"

  case "$BACKEND" in
    hyprpaper)
      hyprctl hyprpaper preload "$selected" >/dev/null 2>&1 || true
      hyprctl hyprpaper wallpaper ", $selected" >/dev/null 2>&1 || true
      hyprctl hyprpaper unload unused >/dev/null 2>&1 || true
      ;;
    awww)
      awww img "$selected"
      ;;
    swww)
      swww img "$selected"
      ;;
    *)
      notify-send "Wallpaper" "Unknown backend: $BACKEND"
      exit 1
      ;;
  esac
}

case "${ROFI_RETV:-0}" in
  0)
    # Build & print menu entries
    # NOTE: rofi expects one entry per line.
    while IFS= read -r -d '' f; do
      base="$(basename "$f")"
      thumb="$(thumb_for "$f")"

      # label shown = base (or change to " " for icons-only)
      # info = full path, so duplicates are safe
      printf '%s\0icon\x1f%s\0info\x1f%s\n' "$base" "$thumb" "$f"
    done < <(
      find "$WALL_DIR" -type f \( \
        -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \
      \) -print0 | sort -z
    )
    ;;

  1)
    # User selected an entry
    selected="${ROFI_INFO:-}"
    [[ -n "$selected" ]] || exit 0
    apply_wallpaper "$selected"
    ;;

  *)
    exit 0
    ;;
esac

