#!/usr/bin/env bash
# Scans the starting image and the reference solution with Grype. The
# starting image must have many critical and high vulnerabilities with a fix
# available, and the solution none, while still serving the app. Removes
# everything it created when it finishes.
set -euo pipefail
cd "$(dirname "$0")"

context=$(mktemp -d)
cleanup() {
  docker rm -f patched-app >/dev/null 2>&1 || true
  docker rmi -f patched-app-src patched-app >/dev/null 2>&1 || true
  docker volume rm grype-db >/dev/null 2>&1 || true
  rm -rf "$context"
}
trap cleanup EXIT

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

grype() {
  docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v grype-db:/grype-db -e GRYPE_DB_CACHE_DIR=/grype-db \
    -e GRYPE_DB_AUTO_UPDATE=false \
    anchore/grype:v0.121.0 "$@"
}

# Download the vulnerability database once, into a volume, for both scans
grype db update >/dev/null

# Prints the number of critical and high vulnerabilities with a fix available
count_fixable() {
  grype "$1" --only-fixed -o json -q \
    | python3 -c '
import json, sys
matches = json.load(sys.stdin)["matches"]
print(sum(m["vulnerability"]["severity"] in ("Critical", "High") for m in matches))'
}

docker build -q -t patched-app-src ../src >/dev/null
src=$(count_fixable patched-app-src)
[ "$src" -ge 100 ] || fail "the starting image has only $src fixable critical or high vulnerabilities"
echo "OK: the starting image has $src critical or high vulnerabilities with a fix available"

# The solution replaces requirements.txt and the Dockerfile of the starting files
cp ../src/app.py Dockerfile requirements.txt "$context"
docker build -q -t patched-app "$context" >/dev/null
sol=$(count_fixable patched-app)
[ "$sol" -eq 0 ] || fail "the solution still has $sol critical or high vulnerabilities with a fix available"
echo "OK: the solution has no critical or high vulnerabilities with a fix available"

docker run -d --name patched-app -p 8016:5000 patched-app >/dev/null
for _ in $(seq 10); do
  if [[ $(curl -sf http://localhost:8016/ || true) == "Hello from a patched image" ]]; then
    echo "OK: the app still works"
    exit 0
  fi
  sleep 1
done
fail "the app does not answer"
