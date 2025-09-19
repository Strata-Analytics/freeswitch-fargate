#!/usr/bin/env bash
set -euo pipefail

export LD_LIBRARY_PATH="/usr/local/freeswitch/lib:/usr/local/lib:${LD_LIBRARY_PATH:-}"

exec /usr/local/freeswitch/bin/freeswitch -u freeswitch -g freeswitch -nf -nonat
