# frozen_string_literal: true

require 'set'

# part1
# detect start of packet marker in stream
# - marker is seq. of 4 characters that are all different
# - report num of characters from beginning of buffer to the end of the first 4 char marker.

## implementation options
# more efficient, more error prone
# - keep track of 3 prev chars plus current char
# - as dups are detected, advance min_marker_pos so that we don't forget a dup occurred

# less efficient, safer + easier to read
# - keep track of 3 prev chars plus current char
# - for each current char, check the seq of 4 for dups (convert to set and compare count)
#   - if no dup detected, return curr idx+1
# picking this option because my computer is fast

# part2 - change 4 to 14 lol

input = ''
File.open('6/input.txt', 'r') do |f|
  input = f.read
end

chars = input.split('')
window = []

chars.each_with_index do |c, i|
  window << c
  next if window.size < 14

  if window.to_set.size == 14
    #   we found marker, return idx+1
    puts "marker complete after #{i+1} chars"
    return
  end

  window.shift
end

raise 'hit end of input'
