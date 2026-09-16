#!/bin/sh
# Source from the project root. Override for an existing Elan installation.
if [ -n "${JSP924_ELAN_HOME:-}" ]; then
  export ELAN_HOME="$JSP924_ELAN_HOME"
elif [ -d "$PWD/.tools/elan/bin" ]; then
  export ELAN_HOME="$PWD/.tools/elan"
fi
if [ -n "${ELAN_HOME:-}" ]; then
  export PATH="$ELAN_HOME/bin:$PATH"
fi
