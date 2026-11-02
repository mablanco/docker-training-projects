#!/usr/bin/env bash
# Builds the three images and runs them on a user-defined network: two PHP
# web servers and an Nginx reverse proxy in front of them.
set -euo pipefail
cd "$(dirname "$0")"

echo "*** Building the images"
docker build -t local/php83 php83
docker build -t local/php85 php85
docker build -t local/proxy nginx

echo "*** Starting the containers"
docker network create php-proxy
docker run -d --name php83 --network php-proxy local/php83
docker run -d --name php85 --network php-proxy local/php85
# Started last: Nginx resolves the names in proxy_pass when it starts, so
# the PHP containers must already exist.
docker run -d --name proxy --network php-proxy -p 8005:80 local/proxy

echo "*** Done. Open http://php83.localhost:8005 and http://php85.localhost:8005"
