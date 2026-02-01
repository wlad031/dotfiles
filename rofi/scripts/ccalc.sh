#!/usr/bin/env bash

if [ "$ROFI_RETV" == "0" ]; then
  echo -e "Calc\n"
  exit 0
elif [ "$ROFI_RETV" == "1" ]; then
  ( sleep 0.1; rofi -modi calc -show calc -no-show-match -no-sort -calc-command "echo -n '{result}' | xclip" >/dev/null 2>&1 ) &
  exit 0
fi

exit 0

