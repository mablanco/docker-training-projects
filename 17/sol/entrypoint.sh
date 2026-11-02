#!/bin/sh
# Prepares the environment and starts the service
set -e
echo "Starting the service as $(id -un)"
# exec replaces the shell with the service, so the service gets the signals
exec python /app/app.py
