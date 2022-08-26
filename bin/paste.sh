#!/bin/bash

# returns: Darwin | Ubuntu | Arch Linux
function get_os() {
  os="$(uname)"
  if [[ -f /etc/os-release ]]; then
    os="$(grep '^NAME' < /etc/os-release)"
  fi
  echo "$os"
}

os="$(get_os)"

if [[ "$os" =~ "Ubuntu" ]]; then
  xclip -o
elif [[ "$os" == Darwin ]]; then
  pbpaste
fi
