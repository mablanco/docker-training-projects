#!/bin/bash
set -e
docker pull wordpress:latest
docker images | grep wordpress
docker pull mysql:latest
docker images | grep mysql
docker run --name mysqlwp -e MYSQL_ROOT_PASSWORD=wordpressdocker -d mysql
docker run --name wordpress --link mysqlwp:mysql --rm -d -p 8002:80 wordpress
