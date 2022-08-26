#!/usr/bin/env bash

set -euo pipefail

tmux new-window -c "$HOME"/wiki
tmux send-keys '$EDITOR' 'Enter'

