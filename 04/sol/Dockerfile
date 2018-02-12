FROM debian:9
RUN apt-get update && \
apt-get -y install \
apache2 \
php7.0 \
php7.0-mysql php7.0-intl php7.0-xsl php7.0-gd php7.0-mcrypt \
php7.0-curl php7.0-mbstring php7.0-soap php7.0-zip \
composer \
wget && \
rm /var/www/html/index.html
RUN wget -q https://api.github.com/repos/magento/magento2/releases/latest -O - \
| grep tarball_url | cut -d : -f 2,3 | tr -d \", \
| wget -qi - -O - \
| tar --strip-components=1 -xzC /var/www/html/
RUN cd /var/www/html && \
composer install && \
chown -R www-data:www-data /var/www/html
RUN a2enmod rewrite
COPY install-magento.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/install-magento.sh
COPY magento.conf /etc/apache2/sites-available
RUN a2ensite magento && a2dissite 000-default
WORKDIR /var/www/html
EXPOSE 80
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
