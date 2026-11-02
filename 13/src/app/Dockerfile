FROM alpine:3.24.3

# The token to download the dataset from the private artifact server
ARG ARTIFACTS_TOKEN

RUN mkdir /data \
 && wget -q --header "Authorization: Bearer ${ARTIFACTS_TOKEN}" \
      -O /data/dataset.txt http://artifacts:8013/dataset.txt

CMD ["cat", "/data/dataset.txt"]
