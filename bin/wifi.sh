#!/usr/bin/env bash

set -euo pipefail

# Darwin | Ubuntu | Arch Linux
os="$(uname)"
if [[ -f /etc/os-release ]]; then
  os="$(grep '^NAME' < /etc/os-release)"
fi

cmd="${1:-}"
if [[ "$cmd" == help || -z "$cmd" ]]; then
  cat <<EOF
Usage:
  help
    print this help

  list
    list wifi networks

  connect <ssid>
    connect to a network
EOF
  exit 0
fi

if [[ "$cmd" == list ]]; then
  if [[ "$os" == Darwin ]]; then
    /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s
    exit 0
  fi
fi

if [[ "$cmd" == connect ]]; then
  ssid="${2:-}"
  if [[ -z "$ssid" ]]; then
    echo "Please provide SSID"
    exit 1
  fi

  password="$(pass show wifi/"$ssid")"
  if [[ -z "$password" ]]; then
    read -s -p 'Password: ' password
  else
    echo "Read password from store"
  fi

  if [[ "$os" == Darwin ]]; then
    echo "Connecting to $ssid"
    networksetup -setairportnetwork en0 "$ssid" "$password"
    exit 0
  fi
fi

if [[ "$cmd" == disconnect ]]; then
  if [[ "$os" == Darwin ]]; then
    echo "Disconnecting from wifi"
    sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport eth0 -z
    exit 0
  fi
fi

