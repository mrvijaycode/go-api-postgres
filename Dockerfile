FROM golang:1.14.6-alpine3.12 as builder

COPY go.mod go.sum /go/src/github.com/mrvijaycode/go-api-postgres/
WORKDIR /go/src/github.com/mrvijaycode/go-api-postgres
RUN go mod download
COPY . /go/src/github.com/mrvijaycode/go-api-postgres
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o build/bucketeer github.com/mrvijaycode/go-api-postgres


FROM alpine

RUN apk add --no-cache ca-certificates && update-ca-certificates
COPY --from=builder /go/src/github.com/mrvijaycode/go-api-postgres/build/bucketeer /usr/bin/bucketeer

EXPOSE 8080 8080

ENTRYPOINT ["/usr/bin/bucketeer"]
