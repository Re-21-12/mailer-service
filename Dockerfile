# ---------- build ----------
FROM golang:1.23-alpine AS builder
WORKDIR /app

<<<<<<< HEAD
# copiar ambos archivos de módulos para aprovechar cache de dependencia
=======
RUN apk add --no-cache git ca-certificates tzdata

>>>>>>> upstream/main
COPY go.mod go.sum ./
RUN go mod download

COPY . .

<<<<<<< HEAD
RUN go build -v -x -o main .

# Etapa 2: Imagen ligera para producción
FROM alpine:latest

RUN apk --no-cache add ca-certificates

COPY --from=builder /app/main /app/main
=======
# Binario estático y compacto
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o /out/mailer-service .
>>>>>>> upstream/main

# ---------- runtime mínimo ----------
FROM scratch
WORKDIR /app

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /out/mailer-service /app/mailer-service

# Copiamos el .env al runtime
COPY .env /app/.env

EXPOSE 8080
ENTRYPOINT ["/app/mailer-service"]
