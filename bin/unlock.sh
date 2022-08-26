#!/usr/bin/env bash

set -euo pipefail

# Export correct tty info before calling pinentry, otherwise it crashes
GPG_TTY=$(tty)
export GPG_TTY

SERIAL=$(gpg-connect-agent 'scd serialno' /bye | head -n 1 | cut -f3 -d' ')
gpg-connect-agent "scd checkpin $SERIAL" /bye
