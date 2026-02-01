#!/usr/bin/env bash

if [ "$ROFI_RETV" == "0" ]; then
  echo -e "CopyQ\n"
elif [ "$ROFI_RETV" == "1" ]; then
  ( sleep 0.1; rofi -replace -modi "copyq" -show "copyq" >/dev/null 2>&1 ) &
fi

exit 0
