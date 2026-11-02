#!/usr/bin/env bash
# Checks that the starting Dockerfile compiles the arm64 binary under
# emulation, and that the reference solution cross-compiles it on the
# builder's platform, pushes an image for amd64 and arm64, and that each one
# has a binary for its architecture. Removes everything it created when it
# finishes.
set -euo pipefail
cd "$(dirname "$0")"

image=localhost:5015/hello-multiarch:1.0
log=$(mktemp)
binary=$(mktemp)

cleanup() {
  docker rm -f registry hello-arm64 >/dev/null 2>&1 || true
  docker buildx rm multiarch >/dev/null 2>&1 || true
  docker rmi -f "$image" >/dev/null 2>&1 || true
  rm -f "$log" "$binary"
}
trap cleanup EXIT

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

BUILDKIT_PROGRESS=plain ../src/run.sh >"$log" 2>&1
grep -qE '^#[0-9]+ \[linux/arm64 build [0-9/]+\] RUN .*go build' "$log" \
  || fail "the starting Dockerfile does not compile under emulation, so there is nothing to fix"
echo "OK: the starting Dockerfile compiles the arm64 binary under emulation"

BUILDKIT_PROGRESS=plain ./run.sh >"$log" 2>&1
grep -qE '^#[0-9]+ \[linux/[a-z0-9]+->arm64 build [0-9/]+\] RUN .*go build' "$log" \
  || fail "the arm64 binary is not cross-compiled on the builder's platform"
echo "OK: the arm64 binary is cross-compiled on the builder's platform"

platforms=$(docker buildx imagetools inspect "$image" --format '{{range .Manifest.Manifests}}{{.Platform.OS}}/{{.Platform.Architecture}} {{end}}')
[[ $platforms == *linux/amd64* && $platforms == *linux/arm64* ]] \
  || fail "the image is not published for amd64 and arm64: $platforms"
echo "OK: the image is published for linux/amd64 and linux/arm64"

# Running the arm64 image needs emulation, so check its binary instead: the
# ELF header has the machine type at offset 18 (0xb7 is AArch64)
docker pull -q --platform linux/arm64 "$image" >/dev/null
docker create --name hello-arm64 --platform linux/arm64 "$image" >/dev/null
docker cp -q hello-arm64:/usr/local/bin/hello "$binary"
[[ $(od -An -tx1 -j18 -N1 "$binary" | tr -d ' ') == b7 ]] \
  || fail "the binary in the arm64 image is not an AArch64 binary"
echo "OK: the arm64 image has an AArch64 binary"
docker rm hello-arm64 >/dev/null

docker pull -q --platform linux/amd64 "$image" >/dev/null
output=$(docker run --rm --platform linux/amd64 "$image")
[[ $output == "Hello from linux/amd64" ]] || fail "the amd64 image prints: $output"
echo "OK: the amd64 image prints \"$output\""
