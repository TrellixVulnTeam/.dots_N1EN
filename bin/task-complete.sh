#!/usr/bin/env bash

set -euo pipefail

current="$(task +ACTIVE export | jq -rM '.[0].id')"
task done "$current"

