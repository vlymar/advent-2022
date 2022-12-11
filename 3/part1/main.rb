require 'set'
# part1
# each line is a rucksack
# rucksack has 24 items
# 12 are first compartment, 12 are second compartment
# find the letter (case-sensitive) that's duplicated between compartments
# assign it score:
# - a-z: 1-26
# - A-Z: 27-52
# return some of scores for all duplicates

def detect_duplicate(line)
    comp_size = line.length / 2
    comp1 = line[0...comp_size].split("").to_set
    comp2 = line[comp_size..-1].split("").to_set
    (comp1 & comp2).first
end

def score_token(token)
    ascii_num = token.bytes.first
    if /[[:upper:]]/.match(token)
        (ascii_num - 38)
    else
        ascii_num - 96
    end
end

def main
    total = 0
    File.open("../input.txt", "r") do |f|
        f.each_line do |line|
            dup = detect_duplicate line
            score = score_token(dup)
            total += score
        end
    end

    puts total
end

main
