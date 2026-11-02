#!/usr/bin/env bash
# Runs the solution and checks that WordPress reaches its database and shows
# the installation page. Removes everything it created when it finishes.
set -euo pipefail
cd "$(dirname "$0")"

cleanup() {
  docker rm -f wordpress mysqlwp >/dev/null 2>&1 || true
  docker network rm wordpress >/dev/null 2>&1 || true
  docker volume rm wordpress-db >/dev/null 2>&1 || true
}
trap cleanup EXIT

./run.sh

# MySQL takes a while to initialize on first start. Until WordPress can
# connect, it answers with "Error establishing a database connection".
# Once it can, a fresh installation redirects to the installation page.
for _ in $(seq 60); do
  url=$(curl -sfL -o /dev/null -w '%{url_effective}' http://localhost:8002/ || true)
  if [[ $url == */wp-admin/install.php ]]; then
    echo "OK: WordPress shows the installation page"
    exit 0
  fi
  sleep 2
done
echo "FAIL: WordPress did not show the installation page" >&2
docker logs wordpress 2>&1 | tail -20 >&2
exit 1
