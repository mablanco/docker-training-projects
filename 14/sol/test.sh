#!/usr/bin/env bash
# Simulates a developer's working copy, with a local node_modules directory,
# and checks that the reference solution leaves it out of the build, does not
# reinstall the dependencies when only the code changes, and installs only
# the production dependencies. Also checks that the starting Dockerfile does
# reinstall them. Removes everything it created when it finishes.
set -euo pipefail
cd "$(dirname "$0")"

context=$(mktemp -d)
cleanup() {
  docker rm -f fast-build >/dev/null 2>&1 || true
  docker rmi -f fast-build >/dev/null 2>&1 || true
  rm -rf "$context"
}
trap cleanup EXIT

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

# Creates a working copy with the starting files, the given Dockerfile and,
# for the solution, its .dockerignore. The local node_modules holds a marker
# file and 50 MB of data, like the dependencies installed on a laptop.
prepare() {
  rm -rf "${context:?}"/*
  cp -r ../src/. "$context"
  cp "$@" "$context"
  mkdir "$context/node_modules"
  touch "$context/node_modules/local-marker"
  head -c 50M /dev/zero > "$context/node_modules/local-data"
}

# Builds and prints whether the npm install step came from the cache
build() {
  local log step
  log=$(docker build --progress=plain -t fast-build "$context" 2>&1)
  step=$(grep -E '^#[0-9]+ \[.*RUN .*npm (ci|install)' <<<"$log" | head -1 | cut -d' ' -f1)
  if grep -q "^$step CACHED" <<<"$log"; then echo cached; else echo run; fi
}

change_code() {
  sed -i "s/Hello from a fast build/Hello again from a fast build/" "$context/server.js"
}

prepare ../src/Dockerfile
build >/dev/null
change_code
[[ $(build) == run ]] || fail "the starting Dockerfile does not reinstall the dependencies, so there is nothing to fix"
echo "OK: the starting Dockerfile reinstalls the dependencies when the code changes"

prepare Dockerfile .dockerignore
build >/dev/null
docker run --rm fast-build test ! -e node_modules/local-marker \
  || fail "the local node_modules directory got into the image"
echo "OK: the local node_modules directory stays out of the image"
docker run --rm fast-build test ! -e node_modules/nodemon \
  || fail "the image has the development dependencies"
echo "OK: the image has only the production dependencies"

change_code
[[ $(build) == cached ]] || fail "changing the code reinstalls the dependencies"
echo "OK: changing the code does not reinstall the dependencies"

docker run -d --name fast-build -p 8014:3000 fast-build >/dev/null
for _ in $(seq 10); do
  if [[ $(curl -sf http://localhost:8014/ || true) == "Hello again from a fast build" ]]; then
    echo "OK: the app serves the changed code"
    exit 0
  fi
  sleep 1
done
fail "the app does not serve the changed code"
