#!/usr/bin/env bash

set -euo pipefail

"$HOME/.dots/bin/task-note.sh" "$(task +ACTIVE export | jq -rM '.[0].id')"
