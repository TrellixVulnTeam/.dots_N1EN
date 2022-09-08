#!/usr/bin/env bash

set -euo pipefail

first=1
for h in $(git log --reverse --format=format:%H); do
  # Skip first commit as there's not parent
  if (( $first )); then
    first=0
    continue
  fi

  git show -s "$h" --format="format:Hash: %H%nAuthor: %an - %ae%nBody: %B%nDate: %cd"

  echo "Open commit $h?"
  read -n1 -rp "[y|n]? " optional
  echo
  if [[ "$optional" =~ y ]]; then
    this_commit="$h"
    previous_commit="$h^"
    git dta "$previous_commit" "$this_commit"
  else
    exit 0
  fi
done

