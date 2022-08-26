#!/usr/bin/env bash

set -euo pipefail

task_id="${1:-}"

if [[ -z "$task_id" ]]; then
  task_id="$(task +PENDING export | jq -rM '.[] | [.id, .description] | @tsv ' | fzf --tac | cut -f 1)"
fi

description="$(task "$task_id" export | jq -rM '.[0].description')"
uuid="$(task "$task_id" export | jq -rM '.[0].uuid')"
file="$HOME/wiki/${uuid}.md"
if [[ -f "$file" ]]; then
  nvim "$file"
else
  nvim +":norm i# ${description}" "$file"
fi
