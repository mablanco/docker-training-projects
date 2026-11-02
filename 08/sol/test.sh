#!/usr/bin/env bash
# Builds the image, runs it with the code mounted from a copy of src/ and
# checks that the app answers and reloads when the code changes.
set -euo pipefail
cd "$(dirname "$0")"

code=$(mktemp -d)
trap 'docker rm -f flask-dev >/dev/null 2>&1; docker rmi -f local/flask-dev >/dev/null 2>&1; rm -rf "$code"' EXIT
cp ../src/app.py "$code"/
chmod -R a+rwX "$code"

docker build -q -t local/flask-dev -f Dockerfile ../src >/dev/null
docker run -d --name flask-dev -p 5000:5000 -v "$code":/app local/flask-dev >/dev/null

wait_for() {
  for _ in $(seq 30); do
    if curl -sf http://localhost:5000/ | grep -q "$1"; then return 0; fi
    sleep 1
  done
  echo "FAIL: the app did not answer \"$1\"" >&2
  docker logs flask-dev >&2
  exit 1
}

wait_for 'Hello World'
echo "OK: the app answers"

# Change the code on the host: the development server must reload it.
sed -i 's/Hello World/Hello Docker/' "$code"/app.py
wait_for 'Hello Docker'
echo "OK: the app reloaded after a code change"
