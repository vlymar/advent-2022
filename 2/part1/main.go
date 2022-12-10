package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strings"
)

/*

Col 1, oponents move
A: Rock
B: Paper
C: Scissors

Col 2, my move
X: Rock
Y: Paper
Z: Scissors

total score = sum of scores for all rounds

round score = shape score + outcome score

points
rock = 1
paper = 2
scissors = 3

loss = 0
3 = draw
6 = win

*/

type move int

const (
	rock     move = 1
	paper         = 2
	scissors      = 3
)

// return (opponentMove, myMove)
func parseMoves(line string) (move, move) {
	tokens := strings.Split(line, " ")

	return parseMove(tokens[0]), parseMove(tokens[1])
}

func parseMove(t string) move {
	switch t {
	case "A", "X":
		return rock
	case "B", "Y":
		return paper
	case "C", "Z":
		return scissors
	default:
		log.Fatalf("malformed input: unrecognized token: %s\n", t)
		return rock // make compiler happy, unreachable code
	}
}

func roundScore(opponentMove, myMove move) int {
	outcomeBonus := 0

	if myMove == opponentMove {
		outcomeBonus = 3 // draw
	} else if lWin(opponentMove, myMove) {
		outcomeBonus = 0 // loss
	} else {
		outcomeBonus = 6 // win
	}

	return outcomeBonus + int(myMove)
}

// returns true only if left wins
func lWin(lMove, rMove move) bool {
	if lMove == rock && rMove == scissors {
		return true
	}

	if lMove == paper && rMove == rock {
		return true
	}

	if lMove == scissors && rMove == paper {
		return true
	}

	return false
}

func main() {
	f, err := os.Open("../input")
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	totalScore := 0

	scanner := bufio.NewScanner(f)
	for scanner.Scan() {
		text := scanner.Text()
		opponentMove, myMove := parseMoves(text)

		totalScore += roundScore(opponentMove, myMove)
	}
	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	// return total score
	fmt.Println(totalScore)
}
