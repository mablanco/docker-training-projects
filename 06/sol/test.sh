#!/usr/bin/env bash
# Builds the image and checks that atop runs and sees the host processes.
set -euo pipefail
cd "$(dirname "$0")"
docker build -q -t local/monitcli . >/dev/null
docker run --rm local/monitcli atop -V
# With --pid host the container sees the host processes, not just its own.
procs=$(docker run --rm --pid host local/monitcli sh -c 'ls /proc | grep -c "^[0-9]"')
echo "Processes visible with --pid host: $procs"
[ "$procs" -gt 5 ]
# One 1-second sample, written to a file because there is no terminal.
docker run --rm --pid host local/monitcli sh -c 'atop -w /tmp/sample 1 1 && test -s /tmp/sample'
echo "OK"
