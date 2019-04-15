FROM golang:1.12.4-alpine3.9  as builder
WORKDIR /go/src/app
COPY main.go .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o hello .

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/hello .
EXPOSE 8080
CMD ["/hello"]
