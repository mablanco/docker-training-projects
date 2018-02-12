FROM alpine:latest
RUN apk add --update --no-cache atop htop iftop && \
rm -rf /var/cache/apk/*
CMD ["atop"]
