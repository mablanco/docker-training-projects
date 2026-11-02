# Build stage: the Go toolchain, only needed to compile.
FROM golang:1.27.3-alpine3.24 AS build
WORKDIR /src
COPY go.mod main.go ./
# A static binary (no cgo), so it runs on an empty image without a C
# library. -s -w strips the debug information to make it smaller.
RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /hello .

# Final stage: an empty image with only the binary.
FROM scratch
COPY --from=build /hello /hello
# scratch has no users, but any numeric ID works. 65534 is "nobody".
USER 65534:65534
EXPOSE 8080
ENTRYPOINT ["/hello"]
