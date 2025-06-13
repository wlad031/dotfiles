#!/bin/bash

if [ "$ROFI_RETV" == "0" ]; then
  echo -e "Calc\n"
elif [ "$ROFI_RETV" == "1" ]; then
  setsid rofi -modi calc -show calc -no-show-match -no-sort -calc-command "echo -n '{result}' | xclip" >/dev/null 2>&1 &
fi


