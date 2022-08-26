#!/usr/bin/env bash

set -euo pipefail

scripts_path="$HOME"/.dots/bin/

declare -A commands=( 
  ["Tmux send pane to"]=tmux-send-pane-to.sh
  ["Tmux join pane from"]=tmux-join-pane-from.sh

  ["Add task"]=task-add
  ["Complete task"]=task-complete.sh
  ["Start task"]=task-switch
  ["Switch task"]=task-switch
  ["Choose task note"]=task-note.sh
  ["Current task note"]=task-current-note.sh

  ["Unlock Yubikey"]=unlock.sh

  ["Logbook popup"]=logbook.sh
  ["Logbook vertical"]="logbook.sh v"
  ["Logbook horizontal"]="logbook.sh h"
  ["Logbook window"]="logbook.sh c"

  ["Kill window"]=kill-window.sh

  ["Start pomodoro"]="pomodoro.sh"
  ["Kill pomodoro"]="pomodoro.sh kill"

  ["Meditate"]=meditate.sh

  ["Git status"]=git-status.sh

  ["Open project"]=open-project
  ["Query db"]=query-db.sh

  ["Random Wiki"]=random-wiki
  ["Wiki"]=wiki.sh

  ["Add password"]=add-password
  ["Copy password"]=copy-password

  ["Unix timestamp now"]=unix-timestamp-now
)

choice="$(printf "%s\n" "${!commands[@]}" | fzf)"
eval "${scripts_path}${commands[$choice]}"

