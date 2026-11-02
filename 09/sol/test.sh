#!/usr/bin/env bash
# Builds and starts the app, then checks the frontend, the API through the
# Nginx proxy and that added books are kept. Removes everything at the end.
set -euo pipefail
cd "$(dirname "$0")"

trap 'docker compose down -v --rmi local >/dev/null 2>&1' EXIT
docker compose up -d --build --wait

base=http://localhost:8080

fail() { echo "FAIL: $*" >&2; docker compose logs >&2; exit 1; }

# Frontend: index.html, also for client-side routes such as /ping.
curl -sf "$base/" | grep -q '<div id="app">' || fail "index.html not served"
curl -sf "$base/ping" | grep -q '<div id="app">' || fail "client-side route /ping not served"

# API through the proxy.
curl -sf "$base/api/ping" | grep -q pong || fail "API not reachable at /api"

# Add a book and read it back several times. With more than one gunicorn
# worker, some requests would go to a worker that doesn't have it.
curl -sf -X POST -H 'Content-Type: application/json' \
  -d '{"title":"Dune","author":"Frank Herbert","read":false}' "$base/api/books" >/dev/null \
  || fail "could not add a book"
for _ in $(seq 10); do
  curl -sf "$base/api/books" | grep -q Dune || fail "added book missing from some responses"
done

id=$(curl -sf "$base/api/books" | sed 's/},{/}\n{/g' | grep Dune | sed 's/.*"id":"\([^"]*\)".*/\1/')
curl -sf -X DELETE "$base/api/books/$id" >/dev/null || fail "could not delete the book"
if curl -sf "$base/api/books" | grep -q Dune; then fail "deleted book still listed"; fi

echo "OK"
