#!/usr/bin/env bash

set -euo pipefail

pane=$(tmux list-panes -s \
  -f '#{!=:#I,#{active_window_index}}' \
  -F "#I.#P: #{b:pane_current_path} #{p3:window_name} [#{pane_current_path}] #{window_activity}" \
  | fzf \
)

target=":${pane%:*}"
tmux join-pane -s "$target"

