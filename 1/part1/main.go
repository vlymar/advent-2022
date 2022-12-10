package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
)

func main() {
	f, err := os.Open("input")
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	scanner := bufio.NewScanner(f)

	richestElfCalories := -1
	richestElfNum := -1

	currElfCalories := 0
	currElfNum := 1

	for scanner.Scan() {
		text := scanner.Text()
		if text == "" {
			// fmt.Printf("elf #%d has %d calories\n", currElfNum, currElfCalories)

			if currElfCalories > richestElfCalories {
				richestElfNum = currElfNum
				richestElfCalories = currElfCalories
				// fmt.Println("-- this elf is the new richest elf")
			}

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

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	fmt.Printf("Elf #%d is the richest, carrying %d calories", richestElfNum, richestElfCalories)
}
