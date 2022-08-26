#!/usr/bin/env bash

set -euo pipefail

window=$(tmux list-windows \
  -f '#{!=:#I,#{active_window_index}}' \
  -F "#I: #{b:pane_current_path} #{p3:window_name} [#{pane_current_path}] #{window_activity}" \
  | sort -rk5 \
  | sed 's|'"$HOME"'|~|; s/\(.*]\).*/\1/' \
  | fzf \
)

target=":${window%:*}"
tmux join-pane -t "$target"
