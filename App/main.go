package main

import (
	"log"
	"math/rand"
	"net/http"
)

func main() {
	http.HandleFunc("/api/v1", getRandomString)
	log.Fatal(http.ListenAndServe(":8081", nil))
}

func getRandomString(w http.ResponseWriter, r *http.Request) {
	// List of strings to choose from
	options := []string{"Investments", "Smallcase", "Stocks", "buy-the-dip", "TickerTape"}

	// Generate a random index within the range of the options slice
	randomIndex := rand.Intn(len(options))

	// Retrieve the random string
	randomString := options[randomIndex]

	// Write the random string directly as the response
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(randomString))
}
