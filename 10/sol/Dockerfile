FROM python:2.7.16-alpine3.9
RUN apk add --no-cache --update libcurl && \
    apk add --no-cache --update --virtual .build-deps curl-dev python-dev build-base
RUN pip install pyresttest
RUN apk del .build-deps
WORKDIR /tests
ENTRYPOINT ["pyresttest"]
