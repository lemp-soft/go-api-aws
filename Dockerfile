# Etapa de compilación
FROM golang:1.23.0 AS build

WORKDIR /app

# Copiar go.mod y go.sum y ejecutar `go mod tidy`
COPY go.mod go.sum ./
RUN go mod tidy

# Copiar todo el código fuente al contenedor
COPY . . 

# Mostrar contenido antes de compilar
RUN echo "Contenido de /app antes de la compilación:" && ls -la /app

# Compilar el binario para linux
RUN GOOS=linux GOARCH=amd64 go build -o go-api-aws .

# Verificación post-compilación
RUN echo "Contenido de /app después de la compilación:" && ls -la /app
RUN echo "Chequeando permisos del binario..." && ls -l /app/go-api-aws

# Etapa final (imagen más pequeña)
FROM alpine:latest

# Instalar herramientas necesarias
RUN apk --no-cache add ca-certificates file libc6-compat

# Definir el directorio de trabajo
WORKDIR /app

# Copiar el binario desde la etapa de compilación
COPY --from=build /app/go-api-aws /usr/local/bin/go-api-aws

# Verificar contenido del directorio binario
RUN echo "Contenido de /usr/local/bin después de copiar el binario:" && ls -la /usr/local/bin/

# Verificar si el binario tiene permisos
RUN echo "Chequeando permisos en /usr/local/bin/go-api-aws..." && ls -l /usr/local/bin/go-api-aws

# Verificar la arquitectura del binario
RUN echo "Chequeando arquitectura del binario..." && file /usr/local/bin/go-api-aws

# Ejecutar el binario en el contenedor
CMD ["/usr/local/bin/go-api-aws"]
