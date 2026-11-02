#!/usr/bin/env bash
# Starts the exercise 09 app, builds the test image and runs it against the
# app on its Compose network. Removes everything at the end.
set -euo pipefail
cd "$(dirname "$0")"

app=../../09/sol
trap 'docker compose --project-directory "$app" down -v --rmi local >/dev/null 2>&1; docker rmi -f local/api-tests >/dev/null 2>&1' EXIT

docker compose --project-directory "$app" up -d --build --wait

# The tests file is the one provided in src/.
docker build -q -t local/api-tests -f Dockerfile ../src >/dev/null
docker run --rm --network flask-vue-crud_default local/api-tests
echo "OK"
