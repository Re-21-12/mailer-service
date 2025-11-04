# ---------- build ----------
FROM golang:1.23-alpine AS builder
WORKDIR /app

# copiar ambos archivos de módulos para aprovechar cache de dependencia
COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go build -v -x -o main .

# Etapa 2: Imagen ligera para producción
FROM alpine:latest

RUN apk --no-cache add ca-certificates

COPY --from=builder /app/main /app/main

WORKDIR /app
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /out/mailer-service /app/mailer-service
EXPOSE 8080
ENTRYPOINT ["/app/mailer-service"]
