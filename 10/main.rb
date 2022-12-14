# frozen_string_literal: true


# single register: X, starts with val 1
# instructions:
# - addx V: after 2 cycles the X register is incremented by V
# - noop takes one cycle, does nothing

# part1
# signal strength = cycle number * X (during cycle, before increment)
# find SS on 20th cycle and every 40 cycles after that
# output sum of these signal strengths


# part2
# sprite: `###`. Position controlled by X register at time of drawing
# CRT: 40x6 pixels
# pixels drawn left to right, row by row
# left-most pixel pos: 0, right-most: 39
# crt draws a pixel per cycle, starting with top left one


class Instruction
  NOOP = 'noop'
  ADDX = 'addx'

  attr_reader :type, :val

  def initialize(instruction, val = 0)
    @type = instruction
    @val = val
  end

  def self.from_str(line)
    case line
    when /noop/
      new(NOOP)
    when /addx/
      _, val = line.strip.split(' ')
      new(ADDX, val.to_i)
    else
      raise "unhandled input: #{line}"
    end
  end

  def to_str
    "instr[#{type}|#{val}]"
  end
end

clock = 1
register = 1
addx_buffer = []
instructions = []

SPRITE = '#'
WIDTH = 40
HEIGHT = 6
crt = Array.new(WIDTH * HEIGHT, '.')

File.open('10/input.txt', 'r') do |f|
  f.each_line do |line|
    instructions << Instruction.from_str(line)
  end
end

while clock <= 240
  # we either process a new instruction or complete a buffered add op
  op_to_buffer = nil
  if addx_buffer.empty?
    instr = instructions.shift

    case instr.type
    when Instruction::NOOP
      nil
    when Instruction::ADDX
      op_to_buffer = instr
    else
      raise('unhandled instruction')
    end
  end

  cursor = clock-1
  if (((cursor) % 40) - register).abs <= 1
    crt[cursor] = SPRITE
  end

  # post instruction phase
  unless addx_buffer.empty?
    add_op = addx_buffer.shift
    register += add_op.val
  end

  addx_buffer << op_to_buffer unless op_to_buffer.nil?

  clock += 1
end

# render CRT
# for each pixel (with idx)
crt.each_with_index do |pixel, i|
  if (i % 40).zero?
    puts
  end
  # print pixel to screen
  print pixel
end

puts