# syntax=docker/dockerfile:1
FROM alpine:3.24.3

# The token is mounted only while this RUN instruction runs, as an
# environment variable, and is not stored in any layer or in the history
RUN --mount=type=secret,id=artifacts_token,env=ARTIFACTS_TOKEN,required=true \
    mkdir /data \
 && wget -q --header "Authorization: Bearer ${ARTIFACTS_TOKEN}" \
      -O /data/dataset.txt http://artifacts:8013/dataset.txt

CMD ["cat", "/data/dataset.txt"]
