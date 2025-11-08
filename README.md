# Microservicio de Envío de Emails

Un microservicio simple en Go para enviar correos electrónicos a través de SMTP.

---

## Configuración Rápida

### 1. Variables de Entorno

Crea un archivo `.env` en la raíz del proyecto con la siguiente configuración:

```env
# Configuración SMTP (Gmail ejemplo)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=tu_email@gmail.com
SMTP_PASSWORD=tu-contraseña-de-aplicación

# Configuración del servidor
SERVER_PORT=8080
SERVER_HOST=localhost

# Timeout en segundos para envío de emails
EMAIL_TIMEOUT=30
```

### 2. Configuración para Gmail

Si usas Gmail, necesitas:

1. Activar la verificación en 2 pasos en tu cuenta de Google.
2. Generar una contraseña de aplicación:
   - Ve a: `Google Account → Security → 2-Step Verification → App passwords`
   - Genera una contraseña para "Mail".
   - Usa esa contraseña en `SMTP_PASSWORD`.

### 3. Ejecutar el Servicio

```bash
# Instalar dependencias
go mod tidy

# Ejecutar
go run main.go
```

El servicio estará disponible en: `http://localhost:8080`

---

## Uso

### Endpoints

- `POST /send-email` - Enviar correo electrónico
- `GET /health` - Verificar estado del servicio

### Ejemplo de envío de correo

````bash
curl -X POST http://localhost:8080/send-email \
  -H "Content-Type: application/json" \
  -d '{
    "to": "destinatario@example.com",
    "subject": "Asunto del correo",
    "body": "<h1>Hola</h1><p>Este es un correo de prueba</p>"
  }'

### 4. Ejecutar con Docker

Si quieres ejecutar el microservicio usando Docker:

```bash
# Construir la imagen del microservicio
docker build -t mailer-service .

# Ejecutar el contenedor
docker run -p 8080:8080 --env-file .env mailer-service
````

### Manual Tecnico

### Microservicio de Envío de Emails

Este microservicio está desarrollado en Go (Golang) y permite enviar correos electrónicos via SMTP, pensado para desacoplar el envío de correos del backend principal.
Funcionalidades principales
• Envío de emails HTML.
• Configuración por variables de entorno.
• Soporte para Gmail mediante contraseñas de aplicación.
• Manejo de timeout en envíos.
• Endpoint /send-email para envío.
• Endpoint /health para monitoreo.
• Dockerfile para despliegue inmediato.
• Workflow GitHub Actions para compilar automáticamente.

## Estructura del Repositorio

mailer-service/
├── .github/
│ └── workflows/
│ └── docker-build-go.yml # Pipeline CI/CD para compilar imagen Docker
│
├── handlers/
│ └── email.go # Lógica de manejo de solicitudes HTTP (send email)
│
├── models/
│ └── email.go # Modelo EmailRequest (to, subject, body)
│
├── storage/
│ └── storage.go # Abstracción interna: conexión SMTP, timeout, envío
│
├── .env.dist # Archivo plantilla para variables de entorno
├── .gitignore
├── Dockerfile # Imagen Docker del microservicio
├── docker-compose.yml # Orquestación local
├── go.mod # Dependencias Go
├── go.sum
├── main.go # Punto de entrada del servidor
├── package-lock.json # No utilizado
└── README.md

### Diagrama de arquitectura

flowchart LR
A[Cliente / Backend Principal] --> B[Mailer Service - Go API]
B --> C[SMTP Server]
C --> D[Proveedor Email (Gmail / Outlook / SMTP)]

### Detalle de microservicios y lenguajes

# Lenguaje:

• Go 1.21+

# Librerías principales:

• net/smtp — envío SMTP
• encoding/json — parseo JSON de peticiones
• net/http — servidor HTTP nativo
• context — manejar timeouts
• log — logging nativo de Go

# Componentes internos:

• handlers/email.go
Maneja la ruta /send-email.
• storage/storage.go
Carga variables SMTP, envía correo y maneja timeout.
• models/email.go
Estructura usada para recibir datos en la API.

### Cómo levantar el sistema localmente

- Crear archivo .env
  SMTP_HOST=smtp.gmail.com
  SMTP_PORT=587
  SMTP_USERNAME=tu_email@gmail.com
  SMTP_PASSWORD=contraseña-app
  SERVER_PORT=8080
  SERVER_HOST=localhost
  EMAIL_TIMEOUT=30
- Instalar dependencias
  go mod tidy
- Ejecutar localmente
  go run main.go
  El servicio estará disponible en:
  http://localhost:8080
- Ejecutar con Docker
- Construir imagen
  docker build -t mailer-service .
- Ejecutar contenedor
  docker compose up -d

### Especificación de endpoints por microservicio

- Health Check
  GET /health
  Responde:
  { "status": "ok" }
- Enviar Email
  POST /send-email
  Cuerpo JSON:
  {
  "to": "destinatario@example.com",
  "subject": "Asunto del correo",
  "body": "<h1>Hola</h1><p>Este es un correo de prueba</p>"
  }

### Seguridad

- SMTP
  • Comunicación con servidor SMTP mediante usuario/contraseña de aplicación.
  • Las credenciales viajan vía variables de entorno.
  • No se guarda ningún correo, contraseña o historial en archivos locales.
- Recomandaciones:
  • Usar contraseña de aplicación de Gmail.
  • No almacenar .env en repositorio.
  • Usar TLS/STARTTLS (Gmail lo aplica automáticamente).

### Posibles errores y soluciones

-Error: "535 Authentication Failed"
-Causas:
SMTP_PASSWORD incorrecto
No usaste contraseña de aplicación de Gmail
-Solución:
Revisar credenciales
Activar 2FA y generar contraseña de aplicación
-Error: "Timeout sending email"
-Solución:
Aumentar EMAIL_TIMEOUT en .env
Verificar conexión con servidor SMTP
-Error: "Cannot connect to SMTP server"
-Soluciones:
Revisar SMTP_HOST y SMTP_PORT
Probar conexión:
telnet smtp.gmail.com 587
-Error: Respuesta HTTP 400 “Invalid payload”
-Solución:
Enviar campos obligatorios:

- to
- subject
- body

-Logs recomendados
• Registrar cada envío con timestamp.
• Registrar errores SMTP.
• Implementar log rotativo (Go ofrece log facilitado).
-Mejoras futuras
• Plantillas HTML para correos.
• Endpoint para adjuntos.
• Autenticación para restringir uso del microservicio.
• Colas con Redis o RabbitMQ.
