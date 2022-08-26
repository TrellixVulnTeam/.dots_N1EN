#!/usr/bin/env bash

set -euo pipefail

selections=$(tmux list-windows \
  -F "#I: #{b:pane_current_path} #{p3:window_name} [#{pane_current_path}] #{window_activity}" \
  | sort -rk5 \
  | sed 's|'"$HOME"'|~|; s/\(.*]\).*/\1/' \
  | fzf \
)
IFS=$'\n' 
for selection in $selections; do
  tmux kill-window -t ":${selection%:*}"
done
unset IFS
