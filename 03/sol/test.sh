#!/usr/bin/env bash
# Starts the stack, waits for the MySQL healthcheck and checks that
# WordPress reaches its database and shows the installation page. Removes
# the containers, network and volume when it finishes.
set -euo pipefail
cd "$(dirname "$0")"

trap 'docker compose down -v >/dev/null 2>&1' EXIT

# --wait returns once the containers are running and the healthy ones have
# passed their healthcheck.
docker compose up -d --wait

for _ in $(seq 30); do
  url=$(curl -sfL -o /dev/null -w '%{url_effective}' http://localhost:8003/ || true)
  if [[ $url == */wp-admin/install.php ]]; then
    echo "OK: WordPress shows the installation page"
    exit 0
  fi
  sleep 2
done
echo "FAIL: WordPress did not show the installation page" >&2
docker compose logs wordpress 2>&1 | tail -20 >&2
exit 1
