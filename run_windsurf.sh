#!/bin/bash
# Proxy settings — override via environment variables (e.g. from a local,
# uncommitted rc file) if your setup differs. Defaults to 127.0.0.1:2080.
PROXY_HOST="${PROXY_HOST:-127.0.0.1}"
PROXY_PORT="${PROXY_PORT:-2080}"

export http_proxy="http://${PROXY_HOST}:${PROXY_PORT}"
export https_proxy="http://${PROXY_HOST}:${PROXY_PORT}"
export ALL_PROXY="socks5://${PROXY_HOST}:${PROXY_PORT}"

/usr/share/windsurf/windsurf \
    --proxy-server="http://${PROXY_HOST}:${PROXY_PORT}" \
    ${PROXY_BYPASS:+--proxy-bypass-list="${PROXY_BYPASS}"}
