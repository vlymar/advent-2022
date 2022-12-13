# frozen_string_literal: true

require 'set'

# part1
# simulate movement of rope (head and tail), count all positions the tail visited at least once
# no pre-determined grid size
# can track position of H and T with just coordinates
# track tail visited cells in Set as "x,y" strings
# file:
# R 1
# U 2
# R 1
# ...

# part2
# there are now 10 knots (H, 8 knots and T)
# each knot follows the knot in front of it using part1 rules

# part1
# h_coords = [0, 0]
# t_coords = [0, 0]

NUM_KNOTS = 10

knots = []
NUM_KNOTS.times do
  knots << [0, 0]
end

visited_t_coords = Set.new

# returns a move vector and dist
def parse_move(line)

  dir, dist_str = line.split(' ')
  dist = dist_str.to_i

  case dir
  when 'U'
    [[0, 1], dist]
  when 'D'
    [[0, -1], dist]
  when 'R'
    [[1, 0], dist]
  when 'L'
    [[-1, 0], dist]
  else
    raise("unhandled input: #{line}")
  end
end

# returns position calculated by applying vector to coords
def apply_move(coords, vector)
  [
    coords[0] + vector[0],
    coords[1] + vector[1]
  ]
end

def recalc_tail_coords(h_coords, t_coords)
  h_x, h_y = h_coords
  t_x, t_y = t_coords

  dist = [
    h_x - t_x,
    h_y - t_y
  ]

  return t_coords if (dist[0]).abs <= 1 && (dist[1]).abs <= 1

  v_x = case dist[0]
        when 2
          1
        when -2
          -1
        else
          dist[0]
        end

  v_y = case dist[1]
        when 2
          1
        when -2
          -1
        else
          dist[1]
        end


  apply_move(t_coords, [v_x, v_y])
end

File.open('9/input.txt', 'r') do |f|
  f.each_line do |line|
    vector, dist = parse_move(line)

    ## part 1
    # dist.times do
    #   h_coords = apply_move(h_coords, vector)
    #   t_coords = recalc_tail_coords(h_coords, t_coords)
    #   visited_t_coords.add(t_coords)
    # end

    # part 2
    dist.times do
      knots[0] = apply_move(knots[0], vector)

      (1...knots.length).each do | i|
        knots[i] = recalc_tail_coords(knots[i-1], knots[i])
      end

      visited_t_coords.add(knots[-1])
    end
  end
end

# output visited set count
puts "num visited T positions: #{visited_t_coords.size}"
