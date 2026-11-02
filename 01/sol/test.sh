#!/usr/bin/env bash
# Checks that the starting Dockerfile still fails to build, then builds the
# reference solution, runs it and checks that WordPress reaches its database
# and shows the installation page. Removes everything it created when it
# finishes.
set -euo pipefail
cd "$(dirname "$0")"

cleanup() {
  docker rm -f wordpress-allinone >/dev/null 2>&1 || true
  docker rmi wordpress-allinone >/dev/null 2>&1 || true
}
trap cleanup EXIT

if docker build -q -t wordpress-allinone ../src >/dev/null 2>&1; then
  echo "FAIL: the starting Dockerfile builds, so there is nothing to fix" >&2
  exit 1
fi
echo "OK: the starting Dockerfile fails to build"

docker build -t wordpress-allinone -f Dockerfile ../src
docker run --name wordpress-allinone -d -p 8001:80 wordpress-allinone

# A fresh installation redirects to the installation page once WordPress can
# connect to its database.
for _ in $(seq 30); do
  url=$(curl -sfL -o /dev/null -w '%{url_effective}' http://localhost:8001/ || true)
  if [[ $url == */wp-admin/install.php ]]; then
    echo "OK: WordPress shows the installation page"
    exit 0
  fi
  sleep 2
done
echo "FAIL: WordPress did not show the installation page" >&2
docker logs wordpress-allinone 2>&1 | tail -20 >&2
exit 1
