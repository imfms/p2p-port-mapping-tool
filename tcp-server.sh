#!/usr/bin/env bash
set -e

# PUNCH_UDP_PORT
# OPEN_SERVICE_IP
# OPEN_SERVICE_PORT
# KCPTUN_ARGUMENTS

KCPTUN_ARGUMENTS="${KCPTUN_ARGUMENTS: }"

set -ex
kcptun-server --target "$OPEN_SERVICE_IP:$OPEN_SERVICE_PORT" --listen ":$PUNCH_UDP_PORT" $KCPTUN_ARGUMENTS &
proxypunch -nosave -noupdate -mode server -port "$PUNCH_UDP_PORT"