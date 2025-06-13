#!/bin/bash

if [ "$ROFI_RETV" == "0" ]; then
  echo -e "Find emoji\n"
elif [ "$ROFI_RETV" == "1" ]; then
  setsid rofi -modi emoji -show emoji -emoji-mode insert_no_copy >/dev/null 2>&1 &
fi

