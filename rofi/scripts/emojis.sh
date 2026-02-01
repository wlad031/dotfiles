#rofi -h | grep -F -- -replace
!/usr/bin/env bash

if [ "$ROFI_RETV" == "0" ]; then
  echo -e "Find emoji\n"
  exit 0
elif [ "$ROFI_RETV" == "1" ]; then
  # echo "rofi -show emoji -modi emoji -emoji-mode insert_no_copy"
  setsid -f rofi  -pid /tmp/rofi.pid -modi emoji -show emoji -emoji-mode insert_no_copy &
  exit 0
fi

exit 0
