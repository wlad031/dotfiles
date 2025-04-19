#!/usr/bin/env bash

tmux split-window -h
if [[ "$SSHS_INSTALLED" = true ]]; then
  sshs
fi

