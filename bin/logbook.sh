#!/usr/bin/env bash

set -euo pipefail

cmd="${1:-}"

if [[ -z "$cmd" ]]; then
  $EDITOR "$HOME"/wiki/logbook.md
  exit
fi

if [[ "$cmd" == v ]]; then
  tmux split-window -h -c "$HOME"/wiki 'vim "$HOME"/wiki/logbook.md'
elif [[ "$cmd" == h ]]; then
  tmux split-window -v -c "$HOME"/wiki 'vim "$HOME"/wiki/logbook.md'
elif [[ "$cmd" == c ]]; then
  tmux new-window -c "$HOME"/wiki 'vim "$HOME"/wiki/logbook.md'
fi
