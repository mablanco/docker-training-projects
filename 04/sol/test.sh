#!/usr/bin/env bash
# Builds and starts the reference solution, and checks that Nextcloud is
# installed, uses Redis, stores files through WebDAV and keeps them after the
# containers are recreated. Removes everything it created when it finishes.
set -euo pipefail
cd "$(dirname "$0")"

url=http://localhost:8004
auth=admin:nextcloud-admin-password

cleanup() {
  docker compose down -v --rmi local >/dev/null 2>&1 || true
}
trap cleanup EXIT

fail() {
  echo "FAIL: $1" >&2
  docker compose logs --tail 30 app >&2
  exit 1
}

docker compose up -d --build --wait --wait-timeout 600

curl -fsS "$url/status.php" | grep -q '"installed":true' || fail "Nextcloud is not installed"
echo "OK: Nextcloud is installed"

lock=$(docker compose exec -T -u www-data app php occ config:system:get memcache.locking)
[[ $lock == '\OC\Memcache\Redis' ]] || fail "file locking does not use Redis"
echo "OK: file locking uses Redis"

echo "Hello Nextcloud" > "${TMPDIR:-/tmp}/nextcloud-test.txt"
curl -fsS -u "$auth" -T "${TMPDIR:-/tmp}/nextcloud-test.txt" "$url/remote.php/dav/files/admin/test.txt"
rm "${TMPDIR:-/tmp}/nextcloud-test.txt"
echo "OK: uploaded a file through WebDAV"

# Recreate the containers, keeping the volumes. The file must still be there,
# and the entrypoint must not try to install Nextcloud again.
docker compose down
docker compose up -d --wait --wait-timeout 600
content=$(curl -fsS -u "$auth" "$url/remote.php/dav/files/admin/test.txt")
[[ $content == "Hello Nextcloud" ]] || fail "the file was lost after recreating the containers"
echo "OK: the file survives recreating the containers"
