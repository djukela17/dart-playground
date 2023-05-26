package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/lol-summoner/v1/get-current-summoner", func(w http.ResponseWriter, r *http.Request) {
		auth := r.Header.Get("Authorization")

		fmt.Println(auth)

		w.WriteHeader(http.StatusOK)
		w.Write([]byte("OK"))
	})

	http.HandleFunc("/lol-champ-select/v1/current-champion", func(w http.ResponseWriter, r *http.Request) {
		const championID = 100

		w.WriteHeader(http.StatusOK)
		fmt.Fprintf(w, "%d", championID)
	})

	if err := http.ListenAndServe(":9090", nil); err != nil {
		panic(err)
	}
}
