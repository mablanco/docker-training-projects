#!/usr/bin/env bash
# Starts the private artifact server with a new random token, builds the app
# image, which downloads a file from the server, and runs it.
set -euo pipefail
cd "$(dirname "$0")"

# Keep the token in a file, as you would with a token from your CI system
head -c 16 /dev/urandom | od -An -tx1 | tr -d ' \n' > artifacts-token
ARTIFACTS_TOKEN=$(cat artifacts-token)

docker rm -f artifacts >/dev/null 2>&1 || true
docker run -d --name artifacts -p 8013:80 \
  -e ARTIFACTS_TOKEN="$ARTIFACTS_TOKEN" \
  -v "$PWD/server/default.conf.template:/etc/nginx/templates/default.conf.template:ro" \
  -v "$PWD/server/dataset.txt:/usr/share/nginx/html/dataset.txt:ro" \
  nginx:1.31.8-alpine3.24 >/dev/null
sleep 1

# "artifacts" resolves to the host during the build, where the server is published
docker build -t private-data \
  --add-host artifacts:host-gateway \
  --build-arg ARTIFACTS_TOKEN="$ARTIFACTS_TOKEN" \
  app

docker run --rm private-data
