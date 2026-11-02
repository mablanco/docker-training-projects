#!/usr/bin/env bash
# Deploys WordPress and MySQL in two containers connected by a user-defined
# network. The database files live in a named volume, so they survive when
# the containers are removed.
set -euo pipefail

docker network create wordpress
docker volume create wordpress-db

docker run -d --name mysqlwp --network wordpress \
  -v wordpress-db:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=wordpressdocker \
  -e MYSQL_DATABASE=wordpress \
  -e MYSQL_USER=wordpress \
  -e MYSQL_PASSWORD=wordpress \
  mysql:8.4.13

# On a user-defined network, containers reach each other by name, so the
# database host is just "mysqlwp".
docker run -d --name wordpress --network wordpress -p 8002:80 \
  -e WORDPRESS_DB_HOST=mysqlwp \
  -e WORDPRESS_DB_NAME=wordpress \
  -e WORDPRESS_DB_USER=wordpress \
  -e WORDPRESS_DB_PASSWORD=wordpress \
  wordpress:7.1.4-php8.4-apache

echo "WordPress will be available at http://localhost:8002 once MySQL has started"
