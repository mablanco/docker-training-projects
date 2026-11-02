# Download and verify the release in a separate stage, so the tarball does
# not end up in any layer of the final image.
FROM alpine:3.24.3 AS download
ARG NEXTCLOUD_VERSION=35.0.2
ADD --checksum=sha256:dfc7955eaec5621de90e031d10f76006173b3f3e31d5d6e174821d1da14f162d \
    https://download.nextcloud.com/server/releases/nextcloud-${NEXTCLOUD_VERSION}.tar.bz2 /nextcloud.tar.bz2
RUN tar -xjf /nextcloud.tar.bz2 \
 && mkdir /nextcloud/data

FROM php:8.4.27-apache-trixie

# PHP extensions required and recommended by Nextcloud. The installer also
# installs the libraries they need and removes the build dependencies.
COPY --from=mlocati/php-extension-installer:2.13.1 /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions apcu bcmath exif gd gmp intl opcache pcntl pdo_mysql redis sysvsem zip

COPY nextcloud.ini "$PHP_INI_DIR/conf.d/"
COPY apache-nextcloud.conf /etc/apache2/conf-available/nextcloud.conf
RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
 && a2enmod headers rewrite \
 && a2enconf nextcloud

COPY --from=download --chown=www-data:www-data /nextcloud /var/www/html
COPY docker-entrypoint.sh /usr/local/bin/

# The code comes from the image, while the configuration and the files
# uploaded by the users live in volumes.
VOLUME ["/var/www/html/config", "/var/www/html/data"]

HEALTHCHECK --interval=10s --start-period=5m \
  CMD ["sh", "-c", "curl -fsS http://localhost/status.php | grep -q '\"installed\":true'"]

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
