require 'set'
# part 2
# for each group of 3 lines:
# find the token that recurs in all lines of group
# get score of token, output sum of all scores

def detect_duplicate(line)
  comp_size = line.length / 2
  comp1 = line[0...comp_size].split('').to_set
  comp2 = line[comp_size..].split('').to_set
  (comp1 & comp2).first
end

def detect_group_duplicate(lines)
  (lines[0].split('').to_set &
    lines[1].split('').to_set &
    lines[2].split('').to_set).first
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
  File.open('../input.txt', 'r') do |f|
    group = []
    f.each_line do |line|
      group << line

      next unless group.size == 3

      dup = detect_group_duplicate(group)
      group.clear

      score = score_token(dup)
      total += score
    end
  end

  puts total
end

main
