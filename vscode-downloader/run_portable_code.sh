#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <relative-install-dir>"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$SCRIPT_DIR/$1"

if [ ! -x "$INSTALL_DIR/code" ]; then
    echo "VS Code portable not found in $INSTALL_DIR. Did you run the install script?"
    exit 1
fi

# Proxy settings — override via environment variables (e.g. from a local,
# uncommitted rc file) if your setup differs. Defaults to 127.0.0.1:2080.
PROXY_HOST="${PROXY_HOST:-127.0.0.1}"
PROXY_PORT="${PROXY_PORT:-2080}"
PROXY_ARGS=(--proxy-server="${PROXY_HOST}:${PROXY_PORT}")
[ -n "${PROXY_BYPASS:-}" ] && PROXY_ARGS+=(--proxy-bypass-list="${PROXY_BYPASS}")

nohup "$INSTALL_DIR/code" "${PROXY_ARGS[@]}" > "${INSTALL_DIR}_output.log" 2>&1 &
