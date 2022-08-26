#!/usr/bin/env bash

set -euo pipefail

arg="${1:-left}"

tmux_status=""

if [[ "$arg" == left ]]; then
  tmux_status=$tmux_status"#[fg=colour7,bg=colour8] $(~/.dots/bin/pomodoro.sh remaining) "
else
  tmux_status=$tmux_status"#[fg=colour0,bg=colour4] Task: $(~/.dots/bin/task-current) #[fg=colour0,bg=colour3] Windows: #{session_windows} "
fi

echo "$tmux_status"

