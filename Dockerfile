FROM golang:1.21-alpine AS builder

WORKDIR /app

COPY . .

RUN go mod init example.com/hello && go mod tidy && go build -o server

FROM alpine:latest
WORKDIR /root/

COPY --from=builder /app/server .

RUN chmod +x /root/server

CMD ["./server"]
