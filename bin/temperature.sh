#!/usr/bin/env bash


# returns: Darwin | Ubuntu | Arch Linux
function get_os() {
  os="$(uname)"
  if [[ -f /etc/os-release ]]; then
    os="$(grep '^NAME' < /etc/os-release)"
  fi
  echo "$os"
}

set -euo pipefail

os="$(get_os)"
if [[ "$os" == Darwin ]]; then
  sudo powermetrics --samplers smc |grep -i "CPU die temperature"
else
  echo "OS Not supported."
fi

