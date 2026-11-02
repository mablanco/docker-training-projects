#!/usr/bin/env bash
# Installs Nextcloud on the first start, upgrades it when the image brings a
# newer version, and then runs the command: Apache by default, or the
# background jobs loop with "cron".
set -euo pipefail

occ() {
  runuser -u www-data -- php /var/www/html/occ "$@"
}

if [[ $1 == cron ]]; then
  while true; do
    runuser -u www-data -- php -f /var/www/html/cron.php
    sleep 300
  done
fi

if ! grep -qs "'installed' => true" /var/www/html/config/config.php; then
  echo "Installing Nextcloud"
  occ maintenance:install \
    --database=mysql \
    --database-host="$MYSQL_HOST" \
    --database-name="$MYSQL_DATABASE" \
    --database-user="$MYSQL_USER" \
    --database-pass="$MYSQL_PASSWORD" \
    --admin-user="$NEXTCLOUD_ADMIN_USER" \
    --admin-pass="$NEXTCLOUD_ADMIN_PASSWORD"

  i=0
  for domain in ${NEXTCLOUD_TRUSTED_DOMAINS:-localhost}; do
    occ config:system:set trusted_domains "$i" --value="$domain"
    i=$((i + 1))
  done

  # Configure the Redis server before telling Nextcloud to use it
  occ config:system:set redis host --value="$REDIS_HOST"
  occ config:system:set redis port --value=6379 --type=integer
  occ config:system:set memcache.local --value='\OC\Memcache\APCu'
  occ config:system:set memcache.distributed --value='\OC\Memcache\Redis'
  occ config:system:set memcache.locking --value='\OC\Memcache\Redis'

  # Background jobs run in the cron container. Heavy daily jobs run at night
  # (from 01:00 UTC), and the mimetype migrations are quick on a new instance.
  occ background:cron
  occ config:system:set maintenance_window_start --value=1 --type=integer
  occ maintenance:repair --include-expensive
elif occ status --output=json | grep -q '"needsDbUpgrade":true'; then
  echo "Upgrading Nextcloud"
  occ upgrade
fi

exec "$@"
