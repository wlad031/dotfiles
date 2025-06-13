#!/bin/bash

CACHE_FILE="${HOME}/.cache/rofi-copyq"
COUNT_FILE="${HOME}/.cache/rofi-copyq.count"
MAX_ITEMS=10

update_cache() {
    current_count=$(copyq count)
    cached_count=$(cat "$COUNT_FILE" 2>/dev/null || echo 0)

    if [ "$current_count" != "$cached_count" ]; then
        : > "$CACHE_FILE"
        limit=$((current_count < MAX_ITEMS ? current_count : MAX_ITEMS))
        for i in $(seq 0 $((limit - 1))); do
            copyq read $i | head -n 1 >> "$CACHE_FILE"
            echo >> "$CACHE_FILE"
        done
        echo "$current_count" > "$COUNT_FILE"
    fi
}

if [ "$ROFI_RETV" = "0" ]; then
    update_cache
    # echo -en "\0prompt\x1fClipboard (latest $MAX_ITEMS)\n"
    cat "$CACHE_FILE"

elif [ "$ROFI_RETV" = "1" ]; then
    selected="$1"
    count=$(copyq count)
    limit=$((count < MAX_ITEMS ? count : MAX_ITEMS))

    for i in $(seq 0 $((limit - 1))); do
        item=$(copyq read $i | head -n 1)
        if [ "$item" = "$selected" ]; then
            copyq copy "$(copyq read $i)"
            break
        fi
    done

elif [ "$ROFI_RETV" = "10" ]; then
    selected="$1"
    count=$(copyq count)
    limit=$((count < MAX_ITEMS ? count : MAX_ITEMS))

    for i in $(seq 0 $((limit - 1))); do
        item=$(copyq read $i | head -n 1)
        if [ "$item" = "$selected" ]; then
            copyq show "$i"
            break
        fi
    done
fi

