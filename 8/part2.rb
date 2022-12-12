# frozen_string_literal: true

# frozen_string_literal: true


# heavyweight but i want to remember how to use objects in ruby
class Tree
  attr_reader :height

  attr_accessor :view_dist_up, :view_dist_down, :view_dist_left, :view_dist_right

  def initialize(height)
    @height = height
    @view_dist_right = 0
    @view_dist_left = 0
    @view_dist_up = 0
    @view_dist_down = 0
  end

  def view_score
    view_dist_up * view_dist_down * view_dist_left * view_dist_right
  end

  def to_s
    "{#{@height}}-{#{view_score}}-#{view_dist_up}#{view_dist_down}#{view_dist_left}#{view_dist_right}"
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

width = grid.first.length
height = grid.size

(1...height - 1).each do |y|
  (1...width - 1).each do |x|
    tree = grid[y][x]

    (y - 1).downto(0).each do |y_1|
      tree.view_dist_up += 1
      break if tree.height <= grid[y_1][x].height
    end

    ((y + 1)...height).each do |y_1|
      tree.view_dist_down += 1
      break if tree.height <= grid[y_1][x].height
    end

    (x - 1).downto(0).each do |x_1|
      tree.view_dist_left += 1
      break if tree.height <= grid[y][x_1].height
    end

    ((x + 1)...width).each do |x_1|
      tree.view_dist_right += 1
      break if tree.height <= grid[y][x_1].height
    end
  end
end

# grid.each do |row|
#   p row.map(&:to_s)
# end

p grid.flatten.map(&:view_score).max
