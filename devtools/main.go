package main

import (
	"fmt"
	"math/rand"
	"net/http"
	"strconv"
	"strings"
)

func main() {
	server := Server{
		currentChampionID: 100,
	}

	if err := http.ListenAndServe(":9090", &server); err != nil {
		panic(err)
	}
}

type Server struct {
	currentChampionID int
}

func (s *Server) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	fmt.Println("serving request: ", r.URL.Path)

	switch {
	case strings.HasPrefix(r.URL.Path, "/lol-champ-select/v1/current-champion"):
		w.WriteHeader(http.StatusOK)
		fmt.Fprintf(w, "%d", s.currentChampionID)

		return

	case strings.HasPrefix(r.URL.Path, "/lol-champ-select/v1/session/my-selection/reroll"):
		s.currentChampionID = 50 + rand.Intn(950)

		w.WriteHeader(http.StatusOK)

		return

	case strings.HasPrefix(r.URL.Path, "/lol-champ-select/v1/session/bench/swap/"):
		parts := strings.Split(r.URL.Path, "/")
		param := parts[len(parts)-1]

		championID, err := strconv.Atoi(param)
		if err != nil {
			w.WriteHeader(http.StatusBadRequest)

			return
		}

		s.currentChampionID = championID
	}

	w.WriteHeader(http.StatusOK)
}
