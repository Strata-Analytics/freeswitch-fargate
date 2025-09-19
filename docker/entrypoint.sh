#!/usr/bin/env bash
set -euo pipefail
# Fallback útil además del ldconfig
export LD_LIBRARY_PATH="/usr/local/freeswitch/lib:/usr/local/lib:${LD_LIBRARY_PATH:-}"
exec /usr/local/freeswitch/bin/freeswitch -u freeswitch -g freeswitch -nf -nonat
