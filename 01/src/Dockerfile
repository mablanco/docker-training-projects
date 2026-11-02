FROM ubuntu:26.04

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      apache2 \
      ca-certificates \
      curl \
      libapache2-mod-php \
      mariadb-server \
      php-mysql \
      supervisor \
 && rm -rf /var/lib/apt/lists/*

ARG WORDPRESS_VERSION=7.1.4
RUN curl -fsSL "https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz" \
      | tar -xz --strip-components=1 -C /var/www/html \
 && rm /var/www/html/index.html \
 && chown -R www-data:www-data /var/www/html

# Create the WordPress database and its user
RUN service mariadb start
RUN mariadb -e "CREATE DATABASE wordpress; \
      CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'secretpw'; \
      GRANT ALL ON wordpress.* TO 'wordpress'@'localhost';"

COPY wp-config.php /var/www/html/
COPY supervisord.conf /etc/supervisor/conf.d/

EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
