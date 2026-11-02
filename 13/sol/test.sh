#!/usr/bin/env bash
# Checks that the starting files leak the token into the image, and that the
# reference solution downloads the dataset without leaving the token in the
# image history, its configuration or any of its layers. Removes everything
# it created when it finishes.
set -euo pipefail
cd "$(dirname "$0")"

work=$(mktemp -d)
cleanup() {
  docker rm -f artifacts >/dev/null 2>&1 || true
  docker rmi -f private-data >/dev/null 2>&1 || true
  rm -f artifacts-token ../src/artifacts-token
  rm -rf "$work"
}
trap cleanup EXIT

# Looks for the token in the history, the configuration and the layers
leaks_token() {
  local token=$1
  docker history --no-trunc private-data | grep -q "$token" && return 0
  docker image inspect private-data | grep -q "$token" && return 0
  rm -rf "${work:?}"/*
  docker save private-data | tar -x -C "$work"
  find "$work" -type f -exec sh -c 'tar -xOf "$1" 2>/dev/null || cat "$1"' _ {} \; \
    | grep -aq "$token"
}

../src/run.sh >/dev/null 2>&1
leaks_token "$(cat ../src/artifacts-token)" \
  || { echo "FAIL: the starting files do not leak the token, so there is nothing to fix" >&2; exit 1; }
echo "OK: the starting files leak the token into the image"
docker rm -f artifacts >/dev/null
docker rmi private-data >/dev/null

output=$(./run.sh 2>/dev/null)
[[ $output == "Licensed dataset, version 1" ]] \
  || { echo "FAIL: the image does not have the dataset: $output" >&2; exit 1; }
echo "OK: the image downloads the dataset"

if leaks_token "$(cat artifacts-token)"; then
  echo "FAIL: the token is in the image" >&2
  exit 1
fi
echo "OK: the token is not in the image history, configuration or layers"
