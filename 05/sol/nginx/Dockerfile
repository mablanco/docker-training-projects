FROM nginx:1.31.9-alpine3.24
# Replace the default site with the proxy configuration.
RUN rm /etc/nginx/conf.d/default.conf
COPY proxy.conf /etc/nginx/conf.d/
