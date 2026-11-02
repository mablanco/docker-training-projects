#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
docker build -t wordpress-allinone .
docker run --name wordpress-allinone -d -p 8001:80 wordpress-allinone
