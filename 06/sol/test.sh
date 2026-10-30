#!/usr/bin/env bash
# Construye la imagen y comprueba que atop funciona y ve los procesos del host.
set -euo pipefail
cd "$(dirname "$0")"
docker build -q -t local/monitcli . >/dev/null
docker run --rm local/monitcli atop -V
# Con --pid host el contenedor ve los procesos del host, no solo los suyos.
procs=$(docker run --rm --pid host local/monitcli sh -c 'ls /proc | grep -c "^[0-9]"')
echo "Procesos visibles con --pid host: $procs"
[ "$procs" -gt 5 ]
# Una muestra de 1 segundo, escrita en un fichero porque no hay terminal.
docker run --rm --pid host local/monitcli sh -c 'atop -w /tmp/sample 1 1 && test -s /tmp/sample'
echo "OK"
