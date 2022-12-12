# frozen_string_literal: true


# heavyweight but i want to remember how to use objects in ruby
class Tree
  attr_reader :height

  def initialize(height)
    @height = height
    @visible = false # visible from edge
  end

  def visible?
    @visible
  end

  def mark_visible!
    @visible = true
  end

  def to_s
    "{#{@height}-{#{visible?}}"
  end
end

grid = []

# parse file and build tree grid (2d arr) of rows of trees
File.open('8/input.txt', 'r') do |f|
  f.each_line do |line|
    grid << line.strip.split('').map do |c|
      Tree.new(c.to_i)
    end
  end
end

grid.each do |row|
  max = -1
  row.each do |tree|
    if tree.height > max
      tree.mark_visible!
      max = tree.height
    end
  end

  max = -1
  row.reverse_each do |tree|
    if tree.height > max
      tree.mark_visible!
      max = tree.height
    end
  end
end

width = grid.first.length
height = grid.length

(0...width).each do |col_idx|
  max = -1
  (0...height).each do |row_idx|
    tree = grid[row_idx][col_idx]
    if tree.height > max
      tree.mark_visible!
      max = tree.height
    end
  end

  max = -1
  (0...height).reverse_each do |row_idx|
    tree = grid[row_idx][col_idx]
    if tree.height > max
      tree.mark_visible!
      max = tree.height
    end
  end
end

# grid.each do |row|
#   p row.map(&:to_s)
# end

p grid.flatten.map(&:visible?).count(true)