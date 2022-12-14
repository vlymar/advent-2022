# frozen_string_literal: true

# starting items: worry value per item
# operation: how your worry level changes when monkey inspects item
# test: how monkey decides where to throw an item
# monkey procedure:
# 1. inspect item. if holding no items, turn over
# 2. apply operation
# 3. divide by 3 and floor
# 4. test and throw. item lands at end of destination's list
# 5. repeat till inspected all items (L -> R)
#
# monkeys all do this procedure in file order

# part1:
# count the total number of times each monkey inspects items over 20 rounds
# pick the 2 monkeys with the most inspections, multiply their counts and output that

class Monkey
  @all = []

  def initialize(starting_items:, operation:, test_val:, throw_target_t:, throw_target_f:)
    @starting_items = starting_items
    @operation = operation
    @test_val = test_val
    @throw_target_true = throw_target_t
    @throw_target_false = throw_target_f

    @inspect_count = 0
    self.class.all << self
  end

  def self.all
    @all
  end

  # - starting_items: []
  # - operation: lambda
  # - test_val
  # - throw_target_true
  # - throw_target_false
  # - inspect_count
end

# parse file into array of monkeys
File.open('11/sample_input.txt', 'r') do |f|
  data = { starting_items: [1, 2] }

  f.each_line do |line|
    instr_name, instr_val = line.split(':')

    case instr_name.strip
    when /Monkey/
      data = {} # reset
    when 'Starting items'
      nums = instr_val.split(',').map(&:strip).map(&:to_i)
      data[:starting_items] = nums
    when 'Operation'
      # TODO: extract into func
      # TODO: test func
      op_symbol, val = /new = old ([+|*]) (\d+|old)/.match(instr_val)[1..2]

      data[:operation] = if op_symbol == '+'
                           if val == 'old'
                             lambda { |x| x + x }
                           else
                             lambda { |x| x + val.to_i }
                           end
                         else
                           if val == 'old'
                             lambda { |x| x * x }
                           else
                             lambda { |x| x * val.to_i }
                           end
                         end
    when 'Test'
      num = /divisible by (\d+)/.match(instr_val)[1]
      data[:test_val] = num.to_i
    when /If true/
      target = /throw to monkey (\d+)/.match(instr_val)[1]
      data[:throw_target_t] = target.to_i
    when /If false/
      target = /throw to monkey (\d+)/.match(instr_val)[1]
      data[:throw_target_f] = target.to_i
    else
      if line == "\n" # couldn't figure out how to match this in a `when` 🤔
        Monkey.new(**data)
      else
        raise("unhandled input: #{line == "\n"}")
      end
    end

  end
end

p Monkey.all

# Monkey 0:
#   Starting items: 79, 98
# Operation: new = old * 19 # only + and * present in input
# Test: divisible by 23
#   If true: throw to monkey 2
#   If false: throw to monkey 3

# repeat $rounds times
# for each monkey
#   - monkey insects all items

# pick 2 largest monkey inspect counts and multiply them