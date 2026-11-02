FROM golang:1.27.3-alpine3.24 AS build
WORKDIR /src
COPY go.mod main.go ./
RUN CGO_ENABLED=0 go build -o /hello .

FROM alpine:3.24.3
COPY --from=build /hello /usr/local/bin/hello
CMD ["hello"]
