#!/usr/bin/env bash
set -e
/var/www/html/bin/magento setup:install \
--base-url=http://127.0.0.1/ --use-secure=0 --base-url-secure=0 --use-secure-admin=0 \
--db-host=mysql --db-name=magento --db-user=magento --db-password=magento \
--admin-firstname=Super --admin-lastname=User --admin-email=user@example.com \
--admin-user=admin --admin-password=admin123 --language=en_US \
--currency=USD --timezone=America/Los_Angeles --cleanup-database \
--session-save=db --backend-frontname=admin --use-rewrites=1
/var/www/html/bin/magento cache:flush
/var/www/html/bin/magento setup:di:compile
chown -R www-data:www-data /var/www/html/
