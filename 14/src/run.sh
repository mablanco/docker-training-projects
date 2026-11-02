#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
docker build -t fast-build .
docker run -d --name fast-build -p 8014:3000 fast-build
