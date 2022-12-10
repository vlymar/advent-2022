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

Col 2, desired outcome
X: lose
Y: draw
Z: win

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
type outcome int

const (
	rock     move = 1
	paper         = 2
	scissors      = 3

	draw outcome = 3
	win          = 6
	loss         = 0
)

// return (opponentMove, desiredOutcome)
func parseStrategy(line string) (move, outcome) {
	tokens := strings.Split(line, " ")

	return parseMove(tokens[0]), parseDesiredOutcome(tokens[1])
}

func parseDesiredOutcome(t string) outcome {
	switch t {
	case "X":
		return loss
	case "Y":
		return draw
	case "Z":
		return win
	default:
		log.Fatalf("malformed input: unrecognized token: %s\n", t)
		return loss // make compiler happy, unreachable code
	}
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

// given an opponent's move and a desired outcome, pick my move and return the round score
func roundScore(opponentMove move, desiredOutcome outcome) int {
	if desiredOutcome == draw {
		return int(opponentMove) + int(draw)
	}

	if opponentMove == rock {
		if desiredOutcome == win {
			return int(win) + int(paper)
		} else {
			return int(loss) + int(scissors)
		}
	}

	if opponentMove == paper {
		if desiredOutcome == win {
			return int(win) + int(scissors)
		} else {
			return int(loss) + int(rock)
		}
	}

	// opponent's move is scissors
	if desiredOutcome == win {
		return int(win) + int(rock)
	} else {
		return int(loss) + int(paper)
	}
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
		opponentMove, desiredOutcome := parseStrategy(text)

		totalScore += roundScore(opponentMove, desiredOutcome)
	}
	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	// return total score
	fmt.Println(totalScore)
}
