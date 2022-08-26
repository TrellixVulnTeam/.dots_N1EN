#!/usr/bin/env bash

set -euo pipefail

timer="/tmp/pomodoro"
cmd="${1:-}"

if [[ "$cmd" == "help" ]]; then
  cat <<EOF
  Print time left:
    ./pomodoro.sh remaining

  Start a pomodoro (25 minutes):
    ./pomodoro.sh

  Start a pomodoro with a time:
    ./pomodoro.sh 35

  Kill a running pomodoro:
    ./pomodoro.sh kill
EOF
  exit 0
fi

if [[ "$cmd" == "kill" ]]; then
  rm -f "$timer"
  exit 0
fi

if [[ "$cmd" == "remaining" ]]; then
  if [[ -f "$timer" ]]; then
    remaining_seconds="$(cat "$timer")"
    echo "POM: $(( "$remaining_seconds" / 60 ))m"
  else
    echo "POM: X"
  fi
  exit 0
fi

if [[ "$cmd" == "bg" ]]; then
  # Kill any other timers before starting ours
  rm -f "$timer"
  sleep 2
  touch "$timer"
  time=$(( 60 * "${2:-25}" ))

  while [[ "$time" -gt 0 ]]; do
    # If we removed the timer file, exit the pomodoro
    if [[ ! -f "$timer" ]]; then
      exit 1
    fi

    echo $time > "$timer"
    sleep 1
    time=$(( "$time" - 1 ))
  done

  rm -f "$timer"
  notifications=5
  while [[ "$notifications" -gt 0 ]]; do
    terminal-notifier -message "Pomodoro time up!" -sound "Submarine"
    notifications=$(( "$notifications" - 1 ))
    sleep 1
  done
  exit 0
fi

nohup "$0" bg "$@" > /dev/null 2>&1 &
# Calling this from tmux we have to sleep after the command, I'm assuming because tmux tries to kill off this script after it exits, before the nohup has time to finish running
sleep 1

