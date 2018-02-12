#!/usr/bin/env bash
set -e
echo "*** Deploying web infrastructure"
echo; echo "** Building PHP5 image"
docker build -t local/php5:latest php5
echo; echo "** Building PHP7 image"
docker build -t local/php7:latest php7
echo; echo "** Building NGINX image"
docker build -t local/nginx:latest nginx
echo; echo "** Launching PHP5 container"
docker run --rm --name php5 -d local/php5
echo; echo "** Launching PHP7 container"
docker run --rm --name php7 -d local/php7
echo; echo "** Launching NGINX container"
docker run --rm --name proxy --link php5:php5 --link php7:php7 -p 80:80 -d local/nginx
echo; echo "Now go and open http://php5 and http://php7 in your browser"
echo; echo "*** Done!"
