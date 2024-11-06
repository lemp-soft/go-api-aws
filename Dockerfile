# Usar una imagen base de Go
FROM golang:1.23.0 AS build

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar el código fuente
COPY . .

# Descargar las dependencias y construir el binario
RUN go mod tidy
RUN go build -o api-server .

# Usar una imagen base más ligera para producción
FROM alpine:latest

# Copiar el binario de Go desde la imagen anterior
COPY --from=build /app/api-server /usr/local/bin/api-server

# Exponer el puerto en el que la API escuchará
EXPOSE 8080

# Comando para ejecutar la aplicación
CMD ["/usr/local/bin/api-server"]
