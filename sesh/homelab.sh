#!/usr/bin/env bash

tmux split-window -v
if [[ "$SSHS_INSTALLED" = true ]]; then
  sshs
fi

