#!/usr/bin/env bash
set -e

# PUNCH_UDP_HOST
# PUNCH_UDP_PORT
# LOCAL_OPEN_PORT
# KCPTUN_ARGUMENTS

KCPTUN_ARGUMENTS="${KCPTUN_ARGUMENTS: }"

set -ex
proxypunch -nosave -noupdate -mode client -host "$PUNCH_UDP_HOST" -port "$PUNCH_UDP_PORT" &
kcptun-client --remoteaddr "127.0.0.1:41254" --localaddr ":$LOCAL_OPEN_PORT" $KCPTUN_ARGUMENTS