FROM debian:9-slim
RUN apt-get update && \
    apt-get upgrade && \
    apt-get -y install apache2 php7.0 && \
    apt-get clean
COPY index.php /var/www/html/
RUN rm /var/www/html/index.html
VOLUME /var/www/html/
EXPOSE 80
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
