#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
docker build -t graceful-app .
docker run -d --name graceful-app -p 8017:8000 graceful-app
