#!/usr/bin/env bash

set -euo pipefail

PATH="/usr/local/bin:$PATH"
trap 'rm -f "$$.tags"' EXIT
git ls-files | \
  ctags --tag-relative -L - -f"$$.tags"
mv "$$.tags" "tags"
