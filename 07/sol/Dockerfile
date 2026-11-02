FROM debian:13.7-slim

# Apache with the PHP module. --no-install-recommends and removing the apt
# lists keep the image small. The access and error logs go to the
# container's output, so `docker logs` shows them.
RUN apt-get update && \
    apt-get install -y --no-install-recommends apache2 libapache2-mod-php && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/www/html/index.html && \
    ln -sf /dev/stdout /var/log/apache2/access.log && \
    ln -sf /dev/stderr /var/log/apache2/error.log

COPY index.php /var/www/html/

EXPOSE 80
# Apache must run in the foreground: the container stops when its main
# process ends.
CMD ["apache2ctl", "-D", "FOREGROUND"]
