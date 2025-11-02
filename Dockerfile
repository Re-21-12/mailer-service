# Etapa 1: Construcción
FROM golang:1.21-alpine AS builder

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

EXPOSE 8080

CMD ["./main"]
