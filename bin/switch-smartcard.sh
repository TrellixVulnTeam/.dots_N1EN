#!/usr/bin/env bash

set -euo pipefail

gpg-connect-agent "scd serialno" "learn --force" /bye

