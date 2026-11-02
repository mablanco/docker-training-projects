FROM nginx:1.31.8-alpine3.24
COPY nginx.conf /etc/nginx/nginx.conf
COPY site/ /usr/share/nginx/html/
# The nginx user (UID 101) comes with the base image. A numeric UID lets
# Kubernetes check runAsNonRoot without looking inside the image.
USER 101:101
EXPOSE 8080
