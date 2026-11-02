#!/usr/bin/env bash
# Checks that the starting image fails with the hardening options, and that
# the reference solution runs with them, as a numeric non-root user and also
# with an arbitrary UID. Removes everything it created when it finishes.
set -euo pipefail
cd "$(dirname "$0")"

hardening=(--read-only --tmpfs /tmp --cap-drop ALL --security-opt no-new-privileges)

cleanup() {
  docker rm -f hardened-site >/dev/null 2>&1 || true
  docker rmi -f hardened-site-src hardened-site >/dev/null 2>&1 || true
}
trap cleanup EXIT

fail() {
  echo "FAIL: $1" >&2
  docker logs hardened-site 2>&1 | tail -10 >&2
  exit 1
}

# Waits for the page and checks that the access log goes to docker logs
check_site() {
  for _ in $(seq 10); do
    if curl -sf http://localhost:8012/ | grep -q "Hello from a hardened container"; then
      docker logs hardened-site 2>/dev/null | grep -q '"GET / HTTP' \
        || fail "the access log does not reach docker logs"
      return 0
    fi
    sleep 1
  done
  fail "the site did not answer"
}

docker build -q -t hardened-site-src ../src >/dev/null
docker run -d --name hardened-site "${hardening[@]}" -p 8012:80 hardened-site-src >/dev/null
sleep 3
if curl -sf http://localhost:8012/ >/dev/null; then
  fail "the starting image works with the hardening options, so there is nothing to fix"
fi
docker rm -f hardened-site >/dev/null
echo "OK: the starting image fails with the hardening options"

# The solution adds nginx.conf next to the starting files
context=$(mktemp -d)
trap 'cleanup; rm -rf "$context"' EXIT
cp -r ../src/site Dockerfile nginx.conf "$context"
docker build -q -t hardened-site "$context" >/dev/null

user=$(docker image inspect hardened-site --format '{{.Config.User}}')
uid=${user%%:*}
[[ $uid =~ ^[0-9]+$ ]] && [ "$uid" -ne 0 ] || fail "the image user is not a numeric non-root UID: '$user'"
echo "OK: the image runs as UID $uid"

docker run -d --name hardened-site "${hardening[@]}" -p 8012:8080 hardened-site >/dev/null
check_site
echo "OK: the site works with the hardening options"
docker rm -f hardened-site >/dev/null

docker run -d --name hardened-site "${hardening[@]}" --user 12345:0 -p 8012:8080 hardened-site >/dev/null
check_site
echo "OK: the site also works with an arbitrary UID"
