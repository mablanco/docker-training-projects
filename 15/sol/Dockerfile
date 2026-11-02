# syntax=docker/dockerfile:1

# The build stage always runs on the platform of the builder ($BUILDPLATFORM),
# without emulation, and Go cross-compiles for the target platform
FROM --platform=$BUILDPLATFORM golang:1.27.3-alpine3.24 AS build
ARG TARGETOS TARGETARCH
WORKDIR /src
COPY go.mod main.go ./
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -o /hello .

# The final stage uses the image of the target platform. It only copies
# files, so it does not need emulation either.
FROM alpine:3.24.3
COPY --from=build /hello /usr/local/bin/hello
USER 65534:65534
CMD ["hello"]
