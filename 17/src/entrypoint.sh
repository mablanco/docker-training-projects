#!/bin/sh
# Prepares the environment and starts the service
set -e
echo "Starting the service as $(id -un)"
python /app/app.py
