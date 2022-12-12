# frozen_string_literal: true

# input file is shell history.
# $ <cmd> <arg>
# cmd is one of `cd`, `ls`
# cd args: <dest>, ..
# ls outputs lines with the file size and file name or "dir X" where X is the dirname
# root dir is /

# part1
# find all dirs with total size <= 100000, then calculate the sum of their total sizes
# question: is the command log doing a depth first search?
# - it sure looks like it is...
# my first thought was that I'd build a tree, but it looks like the log already builds the tree for me
# i can follow along with the depth-first traversal
# - cd <dest> puts dest onto our stack
# - whenever we see file sizes in output of ls, add sizes to sum for dir at top of stack
# - whenever we cd .. pop dir from stack, if its size is less than THRESH:
#   - add its size to a running total, and add its size to sum for dir at top of stack

# question: are dir names unique?
# - it looks like they are but i don't love assuming that...
#   ❯ grep dir input.txt | wc -l
# 174
#
#   ❯ grep dir input.txt | wc -l | sort --uniq
# 174
# so I've confirmed all dir names are uniq. i'm going to build the simplest solution for this input
# but will consider more generalizable solutions

THRESHOLD = 100_000

running_total = 0

stack = []

File.open('7/sample_input.txt', 'r') do |f|
  f.each_line do |line|
    p line

    case line
    when /\$ cd \.\./
      visited = stack.shift
      stack.first[:size] += visited[:size]
      running_total += visited[:size] if visited[:size] <= THRESHOLD
    when /^\$ cd .+/
      dirname = /cd (.+)/.match(line)[1]
      stack.unshift({ dir: dirname, size: 0 })
    when /^\$ ls/, /^dir/
      # noop
    when /^\d+/
      filesize = /^(\d+)/.match(line)[1]
      stack.first[:size] += filesize.to_i
    else
      raise("unhandled input: #{line}")
    end

    puts stack
    puts
  end
end

# the user doesn't cd .. to all the way back out after completing traversal so we simulate it here to make sure
# we don't miss any dirs smaller than the threshold
p "final stage"
until stack.empty?
  visited = stack.shift
  stack.first[:size] += visited[:size] unless stack.empty?
  running_total += visited[:size] if visited[:size] <= THRESHOLD
  p stack
end

# output running total
p running_total
