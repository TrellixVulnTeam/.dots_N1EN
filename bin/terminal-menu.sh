#!/usr/bin/env bash

set -euo pipefail

scripts_path="$HOME"/.dots/bin/

declare -A commands=( 
  ["Git status"]=git-status.sh
)

choice="$(printf "%s\n" "${!commands[@]}" | fzf)"
eval "${scripts_path}${commands[$choice]}"

