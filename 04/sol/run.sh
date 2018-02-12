#!/usr/bin/env bash
set -e
docker build -t local/magento2:latest .
docker run --rm --name=mysql -d -e MYSQL_ALLOW_EMPTY_PASSWORD=true \
-e MYSQL_DATABASE=magento -e MYSQL_USER=magento -e MYSQL_PASSWORD=magento \
mysql/mysql-server:5.7
while true
do
  docker inspect --format '{{ .NetworkSettings.IPAddress }}:3306' mysql \
  | xargs wget --retry-connrefused -q --wait=1 --spider
  if [ $? -eq 0 ]; then
    break
  fi
done
docker run --rm --name magento2 --link mysql -p 80:80 -d local/magento2
docker exec -it magento2 /usr/local/bin/install-magento.sh
