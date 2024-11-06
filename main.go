// main.go
package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

// Handler para la ruta "/"
func HomeHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "¡Hola, Mundo desde Go y Gorilla Mux!")
}

// Handler para la ruta "/api"
func ApiHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, `{"message": "Este es un mensaje desde la API"}`)
}

func main() {
	// Crear un nuevo router de mux
	r := mux.NewRouter()

	// Definir las rutas
	r.HandleFunc("/", HomeHandler)
	r.HandleFunc("/api", ApiHandler)

	// Iniciar el servidor en el puerto 8080
	fmt.Println("Servidor escuchando en el puerto 8080...")
	log.Fatal(http.ListenAndServe(":8080", r))
}
