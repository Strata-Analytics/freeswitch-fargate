#!/usr/bin/env bash
set -euo pipefail

exec /usr/local/freeswitch/bin/freeswitch -u freeswitch -g freeswitch -nf -nonat
