#!/bin/bash

set -euo pipefail

declare -A langs
langs[go]="$(find -name '*.go')"
langs[haskell]="$(find -name '*.hs')"
langs[sh]="$(find -name '*.sh')"
langs[c]="$(find -name '*.c' -or -name '*.h')"
langs[cpp]="$(find -name '*.cpp' -or -name '*.h')"
langs[js]="$(find -name '*.js' -or -name '*.ts')"
langs[python]="$(find -name '*.py')"

lang_guess=""
greatest=0
for i in "${!langs[@]}"; do
  count="$(echo "${langs[$i]}" | wc -l)"
  if (( "$count" > "$greatest" )); then
    greatest="$count"
    lang_guess="$i"
  fi
done

echo "Guessed project as $lang_guess"

# If this is a go project
if [[ "$lang_guess" == go ]]; then
  # Use gotags if we have it
  if [[ -x "$(which gotags)" ]]; then
    echo "Generating tags using gotags"
    gotags -R . /usr/local/go/src > tags
    exit 0
  fi
fi

# If this is a haskell project
if [[ "$lang_guess" == haskell ]]; then
  echo "Guessed project as haskell"
  # Use hasktags if we have it
  if [[ -x "$(which hasktags)" ]]; then
    echo "Generating tags using hasktags"
    hasktags --ctags .
    exit 0
  fi
fi

# Otherwise use ctags if we have it
if [[ -x "$(which ctags)" ]]; then
  echo "Found ctags binary"
  # Universal ctags
  if ctags --version | grep 'Universal Ctags' &>/dev/null; then
    echo "Generating tags using Universal Ctags"
    ctags -R .
    exit 0
  else
    # We have GNU ctags
    echo "Generating tags using GNU Ctags"
    "${langs[$lang_guess]}" -print | xargs ctags --append
    exit 0
  fi
fi
