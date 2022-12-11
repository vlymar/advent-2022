# frozen_string_literal: true

def parse_range(range_str)
  range_str.split('-').map(&:to_i)
end

def parse_ranges(range_str1, range_str2)
  [parse_range(range_str1), parse_range(range_str2)]
end

def fully_contained?(range1, range2)
  [[range1, range2], [range2, range1]].each do |left, right|
    return true if left[0] <= right[0] && left[-1] >= right[-1]
  end

  false
end

def overlapping_ranges?(range1, range2)
  [[range1, range2], [range2, range1]].each do |left, right|

    return true if left[0] >= right[0] && left[0] <= right[-1]
  end

  false
end

num_contained_ranges = 0

File.open('4/input.txt', 'r') do |f|
  f.each_line do |line|
    pair = line.strip.split(',')

    range1, range2 = parse_ranges(*pair)

    num_contained_ranges += 1 if overlapping_ranges?(range1, range2)
  end
end

p num_contained_ranges
