#!/bin/bash
set -e
docker build -t wordpress .
docker images | grep wordpress
docker run --name wordpress --rm -d -p 8001:80 wordpress
