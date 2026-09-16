#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
. scripts/env.sh
exec python3 scripts/verify.py "$@"
