FROM ghcr.io/orange-opensource/hurl:8.1.0
WORKDIR /tests
COPY tests.hurl .
# Default address of the API: the Nginx service of exercise 09, reached by
# its service name on the Compose network. Override it with
# -e HURL_VARIABLE_base_url=...
ENV HURL_VARIABLE_base_url=http://client/api
ENTRYPOINT ["hurl", "--test"]
CMD ["tests.hurl"]
