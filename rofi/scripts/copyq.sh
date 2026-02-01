#!/usr/bin/env bash

CACHE_DIR="$HOME/.cache"
CACHE_FILE="$CACHE_DIR/rofi-copyq"
META_FILE="$CACHE_DIR/rofi-copyq.meta"

MAX_ITEMS=10
TTL_SECONDS=3

mkdir -p "$CACHE_DIR"

now() { date +%s; }
mtime() { stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0; }

build_cache() {
  # One CopyQ call; size()/read() are valid in CopyQ scripting. :contentReference[oaicite:1]{index=1}
  copyq eval -- "
    var max=${MAX_ITEMS};
    var n=size();
    if (n < max) max=n;
    for (var i=0; i<max; ++i) {
      var t=str(read(i));
      var p=t.split('\n')[0].replace(/\\r/g,' ').trim();
      if (!p) p='(empty)';
      print(i + '\\t' + p + '\\n');
    }
  " 2>/dev/null \
  | while IFS=$'\t' read -r idx preview; do
      [ -z "$idx" ] && continue
      printf '%s\0info\x1f%s\n' "$preview" "$idx"
    done > "$CACHE_FILE"
}

update_cache() {
  local age
  [ -s "$CACHE_FILE" ] || { build_cache; printf '%s\n' "$(now)" > "$META_FILE"; return; }
  age=$(( $(now) - $(mtime) ))
  [ "$age" -lt "$TTL_SECONDS" ] && return
  build_cache
  printf '%s\n' "$(now)" > "$META_FILE"
}

case "$ROFI_RETV" in
  0)
    update_cache
    cat "$CACHE_FILE"
    ;;
  1)
    idx="$ROFI_INFO"
    [ -n "$idx" ] && copyq copy "$(copyq read "$idx" 2>/dev/null)"
    ;;
  10)
    idx="$ROFI_INFO"
    [ -n "$idx" ] && copyq show "$idx"
    ;;
esac

exit 0

