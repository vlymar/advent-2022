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

# part2
# find the smallest dir you can delete to free up enough space for the update
TOTAL_SPACE = 70_000_000
REQUIRED_FREE_SPACE = 30_000_000

#
# running_total = 0 # part1

stack = []

visited_dirs = []

File.open('7/input.txt', 'r') do |f|
  f.each_line do |line|

    case line
    when /\$ cd \.\./
      visited = stack.shift
      stack.first[:size] += visited[:size]
      # running_total += visited[:size] if visited[:size] <= THRESHOLD # part 1
      visited_dirs << visited
    when /^\$ cd .+/
      dirname = /cd (.+)/.match(line)[1]
      stack.unshift({ dir: dirname, size: 0 })
    when /^\$ ls/, /^dir/
      # noop
      next
    when /^\d+/
      filesize = /^(\d+)/.match(line)[1]
      stack.first[:size] += filesize.to_i
    else
      raise("unhandled input: #{line}")
    end

    # puts line
    # puts stack
    # puts
  end
end

# the user doesn't cd .. to all the way back out after completing traversal so we simulate it here to make sure
# we don't miss any dirs smaller than the threshold
puts 'final stage'
required_space = 0
until stack.empty?
  visited = stack.shift
  visited_dirs << visited
  if stack.empty? # we just popped root dir
    required_space = REQUIRED_FREE_SPACE - (TOTAL_SPACE - visited[:size])
  else
    stack.first[:size] += visited[:size]
  end

  # running_total += visited[:size] if visited[:size] <= THRESHOLD # part 1
end

# puts "all dirs:"
# puts visited_dirs
#
# deletable_dirs =
#   visited_dirs.filter { |d| d[:size] >= required_space }
#
# puts
# puts 'deletable dirs:'
# puts deletable_dirs

smallest_deletable_dir =
  visited_dirs.filter { |d| d[:size] >= required_space }
              .min_by { |d| d[:size] }

puts
puts "Required space: #{required_space}"
puts "Smallest deletable dir: #{smallest_deletable_dir}"
