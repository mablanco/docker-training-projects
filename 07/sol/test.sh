#!/usr/bin/env bash
# Builds the image and checks that it serves its own index.php, and then a
# website mounted from the host.
set -euo pipefail
cd "$(dirname "$0")"

site=$(mktemp -d)
trap 'docker rm -f apache-php >/dev/null 2>&1; docker rmi -f local/apache-php >/dev/null 2>&1; rm -rf "$site"' EXIT

docker build -q -t local/apache-php . >/dev/null

wait_for() {
  for _ in $(seq 20); do
    if curl -sf http://localhost:8007/ | grep -q "$1"; then return 0; fi
    sleep 1
  done
  echo "FAIL: the page does not contain \"$1\"" >&2
  docker logs apache-php >&2
  exit 1
}

# The image's own index.php: the phpinfo() page.
docker run -d --name apache-php -p 8007:80 local/apache-php >/dev/null
wait_for 'PHP Version 8'
echo "OK: the image serves phpinfo()"
docker rm -f apache-php >/dev/null

# A website mounted from the host replaces the image's files.
printf '<?php echo "Mounted site, PHP " . PHP_MAJOR_VERSION;\n' > "$site"/index.php
chmod -R a+rX "$site"
docker run -d --name apache-php -p 8007:80 -v "$site":/var/www/html:ro local/apache-php >/dev/null
wait_for 'Mounted site, PHP 8'
echo "OK: the image serves a mounted website"

# The access log goes to the container's output.
docker logs apache-php 2>&1 | grep -q 'GET / ' || { echo "FAIL: no access log in docker logs" >&2; exit 1; }
echo "OK: the access log is in docker logs"
