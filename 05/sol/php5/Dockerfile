FROM debian:8
RUN apt-get update && apt-get -y install \
apache2 \
php5
COPY index.php /var/www/html/
RUN rm /var/www/html/index.html
EXPOSE 80
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
