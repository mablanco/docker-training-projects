#!/usr/bin/env bash
# Checks that the starting image does not stop gracefully, and that the
# reference solution reports itself healthy, reaps the zombie processes of
# its background jobs and stops gracefully and quickly. Removes everything
# it created when it finishes.
set -euo pipefail
cd "$(dirname "$0")"

context=$(mktemp -d)
cleanup() {
  docker rm -f graceful-app >/dev/null 2>&1 || true
  docker rmi -f graceful-app-src graceful-app >/dev/null 2>&1 || true
  rm -rf "$context"
}
trap cleanup EXIT

fail() {
  echo "FAIL: $1" >&2
  docker logs graceful-app 2>&1 | tail -10 >&2
  exit 1
}

wait_for_app() {
  for _ in $(seq 10); do
    curl -sf http://localhost:8017/health >/dev/null && return 0
    sleep 1
  done
  fail "the app does not answer"
}

# Stops the container with a 3-second grace period and prints the time taken
timed_stop() {
  local start
  start=$(date +%s)
  docker stop -t 3 graceful-app >/dev/null
  echo $(($(date +%s) - start))
}

docker build -q -t graceful-app-src ../src >/dev/null
docker run -d --name graceful-app -p 8017:8000 graceful-app-src >/dev/null
wait_for_app
timed_stop >/dev/null
[[ $(docker inspect graceful-app --format '{{.State.ExitCode}}') == 137 ]] \
  || fail "the starting image stops gracefully, so there is nothing to fix"
docker rm graceful-app >/dev/null
echo "OK: the starting image is killed when it is stopped"

cp ../src/app.py Dockerfile entrypoint.sh "$context"
docker build -q -t graceful-app "$context" >/dev/null
docker run -d --name graceful-app -p 8017:8000 graceful-app >/dev/null
wait_for_app

for _ in $(seq 20); do
  [[ $(docker inspect graceful-app --format '{{.State.Health.Status}}') == healthy ]] && break
  sleep 1
done
[[ $(docker inspect graceful-app --format '{{.State.Health.Status}}') == healthy ]] \
  || fail "the container is not reported as healthy"
echo "OK: the container is reported as healthy"

for _ in $(seq 5); do
  curl -sf http://localhost:8017/report >/dev/null
done
sleep 2
zombies=$(docker exec graceful-app ps -o stat | grep -c Z || true)
[ "$zombies" -eq 0 ] || fail "$zombies zombie processes were not reaped"
echo "OK: the zombie processes of the background jobs are reaped"

seconds=$(timed_stop)
[ "$seconds" -lt 3 ] || fail "stopping the container took $seconds seconds"
[[ $(docker inspect graceful-app --format '{{.State.ExitCode}}') == 0 ]] \
  || fail "the container did not exit with code 0"
logs=$(docker logs graceful-app 2>&1)
grep -q "Received SIGTERM, shutting down gracefully" <<<"$logs" \
  || fail "the service did not receive SIGTERM"
echo "OK: the service receives SIGTERM and stops gracefully in $seconds seconds"
