#!/usr/bin/env bash
# Builds the image, checks its size and user, and that the web server answers.
set -euo pipefail
cd "$(dirname "$0")"

trap 'docker rm -f go-hello >/dev/null 2>&1; docker rmi -f local/go-hello >/dev/null 2>&1' EXIT

docker build -q -t local/go-hello -f Dockerfile ../src >/dev/null

size=$(docker image inspect local/go-hello --format '{{.Size}}')
echo "Image size: $((size / 1024 / 1024)) MB"
[ "$size" -lt $((20 * 1024 * 1024)) ] || { echo "FAIL: the image is bigger than 20 MB" >&2; exit 1; }

user=$(docker image inspect local/go-hello --format '{{.Config.User}}')
[ -n "$user" ] && [ "${user%%:*}" != 0 ] && [ "${user%%:*}" != root ] \
  || { echo "FAIL: the image runs as root" >&2; exit 1; }

docker run -d --name go-hello -p 8080:8080 local/go-hello >/dev/null
for _ in $(seq 10); do
  if [ "$(curl -sf http://localhost:8080/Docker || true)" = "Hello Docker" ]; then
    echo "OK"
    exit 0
  fi
  sleep 1
done
echo "FAIL: the server did not answer \"Hello Docker\"" >&2
exit 1
