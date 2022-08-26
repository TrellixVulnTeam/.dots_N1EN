#!/usr/bin/env bash

set -euo pipefail

workingdir="$(nvr --remote-expr 'getcwd()')"
cd $workingdir
tig status
