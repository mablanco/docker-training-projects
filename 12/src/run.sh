#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
docker build -t hardened-site .
docker run -d --name hardened-site -p 8012:80 hardened-site
