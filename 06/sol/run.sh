#!/usr/bin/env bash
set -e
docker build -t local/monitcli .
docker run --rm -it --pid host local/monitcli
