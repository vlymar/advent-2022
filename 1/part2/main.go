package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"sort"
	"strconv"
)

// slow, but very fast in the grand scheme of things
func keep3RichestElves(richestElves []int, candidateCalories int) []int {
	richestElves = append(richestElves, candidateCalories)

	sort.Ints(richestElves)

	if len(richestElves) > 3 {
		richestElves = richestElves[1:4]
	}

	return richestElves
}

func sumCalories(richestElves []int) int {
	sum := 0
	for _, c := range richestElves {
		sum += c
	}
	return sum
}

func main() {
	f, err := os.Open("../input")
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	scanner := bufio.NewScanner(f)

	richestElves := []int{}

	currElfNum := 1
	currElfCalories := 0

	for scanner.Scan() {
		text := scanner.Text()
		if text == "" {
			richestElves = keep3RichestElves(richestElves, currElfCalories)

			currElfNum += 1
			currElfCalories = 0
		} else {
			val, err := strconv.Atoi(text)
			if err != nil {
				log.Fatal(err)
			}

			currElfCalories += val
		}
	}

	// last time since EOF isn't a newline
	richestElves = keep3RichestElves(richestElves, currElfCalories)

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	fmt.Println(richestElves)

	fmt.Println(sumCalories(richestElves))
}
