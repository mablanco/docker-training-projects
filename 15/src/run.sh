#!/usr/bin/env bash
# Starts a local registry, creates a builder that can build for several
# platforms, and builds and pushes the image for amd64 and arm64.
set -euo pipefail
cd "$(dirname "$0")"

image=localhost:5015/hello-multiarch:1.0

if ! docker container inspect registry >/dev/null 2>&1; then
  docker run -d --name registry -p 5015:5000 registry:3.1.2 >/dev/null
fi

# The default builder can only store single-platform images. A builder with
# the docker-container driver can build and push multi-platform ones. Host
# networking lets it reach the registry on localhost.
if ! docker buildx inspect multiarch >/dev/null 2>&1; then
  docker buildx create --name multiarch --driver docker-container --driver-opt network=host
fi

docker buildx build --builder multiarch \
  --platform linux/amd64,linux/arm64 \
  -t "$image" --push .

docker buildx imagetools inspect "$image"
