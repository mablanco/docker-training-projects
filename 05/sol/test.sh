#!/usr/bin/env bash
# Runs the solution and checks that each host name reaches its PHP version
# and that other names get a 404. Removes everything at the end.
set -euo pipefail
cd "$(dirname "$0")"

trap 'docker rm -f proxy php83 php85 >/dev/null 2>&1; docker network rm php-proxy >/dev/null 2>&1; docker rmi -f local/proxy local/php83 local/php85 >/dev/null 2>&1' EXIT

./run.sh >/dev/null 2>&1

check() {
  for _ in $(seq 20); do
    if curl -sf "http://$1.localhost:8005/" | grep -q "PHP Version $2"; then
      echo "OK: $1.localhost serves PHP $2"
      return 0
    fi
    sleep 1
  done
  echo "FAIL: $1.localhost does not serve PHP $2" >&2
  docker logs proxy >&2
  exit 1
}

check php83 8.3
check php85 8.5

code=$(curl -s -o /dev/null -w '%{http_code}' http://other.localhost:8005/)
[ "$code" = 404 ] || { echo "FAIL: an unknown host name got $code instead of 404" >&2; exit 1; }
echo "OK: unknown host names get a 404"
