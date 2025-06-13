#!/bin/bash

if [ "$ROFI_RETV" == "0" ]; then
  echo -e "CopyQ\n"
elif [ "$ROFI_RETV" == "1" ]; then
  setsid rofi -modi "copyq" -show "copyq" >/dev/null 2>&1 &
fi

