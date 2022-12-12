# frozen_string_literal: true

# part 1
# 1. parse file into stacks and movelist
# - first section is stacks
# - stacks are comprised of containers
# - containers look like [X] where X is an uppercase letter
# - stacks are cols seperated by spaces
# - there is tailing line of stack indexes, ignore
# - the second section is seperated by two newlines
# - second section looks like `move 14 from 1 to 2`
# 2. execute all moves against stacks
# 3. output the top container's letter for each stack

def parse_stack_line(line)
  p line
end

# stacks represented by 2d array
# subarrays are stacks from left to right
# each subarray is a stack of containers from top to bottom
# stacks are bottom-aligned
def parse_stacks(lines)
  stacks = []

  lines.each do |l|
    # chunk string into groups of 3 or 4 characters
    # needs to be 3 or 4 because this regex doesn't count newline chars for some reason
    # it is hungry though and will count 4 if it can
    l.scan(/.{3,4}/) # group row into slots
     .map(&:strip)   # collapse empty slots into ""
     .each_with_index do |slot, i| # for each slot

      # init stack if we don't have one yet
      stacks << [] while stacks.length <= i

      unless slot.empty?
        container = /\[([A-Z])\]/.match(slot)[1]
        stacks[i] << container
      end
    end
  end
  stacks
end

def parse_moves(lines)
  moves = []

  lines.map do |line|
    quant, source, dest = /move (\d+) from (\d+) to (\d)/.match(line).captures

    moves << [quant.to_i, source.to_i, dest.to_i]
  end

  moves
end

def apply_moves_part_1(stacks, moves)
  # puts "starting moves ---"
  moves.each do |quant, source, dest|
    # p "applying move #{[quant, source, dest]}"
    quant.times do
      container = stacks[source - 1].shift
      stacks[dest - 1].unshift(container)
    end

    # p "stacks: #{stacks}"
  end

  stacks
end

def apply_moves_part_2(stacks, moves)
  # puts "starting moves ---"
  moves.each do |quant, source, dest|
    # p "applying move #{[quant, source, dest]}"
    containers = stacks[source - 1].shift(quant)
    stacks[dest - 1].unshift(containers).flatten!
    # p "stacks: #{stacks}"
  end

  stacks
end

def read_top(stacks)
  stacks.map(&:first).join
end

def parse_input(filename)
  stacks = []
  moves = []

  reading_stacks = true
  File.open(filename, 'r') do |f|
    f.each_line do |line|
      # switch to writing moves when first move detected
      reading_stacks = false if line[0] == 'm'

      if reading_stacks
        stacks << line
      else
        moves << line
      end
    end
  end

  stacks.pop # drop empty line
  stacks.pop # drop the stack index tail row

  [stacks, moves]
end

stack_lines, move_lines = parse_input('5/input.txt')

stacks = parse_stacks(stack_lines)
moves = parse_moves(move_lines)
restacked = apply_moves_part_2(stacks, moves)

p read_top(restacked)

