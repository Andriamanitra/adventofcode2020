TREE = '#'
record Slope, right : Int32, down : Int32

def count_trees(forest : Array(String), slope : Slope)
  forest
    .each.step(slope.down)
    .zip(0.step(by: slope.right))
    .count { |line, index| line.char_at(index % line.size) == TREE }
end

def part1(input)
  forest = input.split
  count_trees(forest, Slope.new(right: 3, down: 1))
end

def part2(input)
  forest = input.split
  [Slope.new(1, 1),
   Slope.new(3, 1),
   Slope.new(5, 1),
   Slope.new(7, 1),
   Slope.new(1, 2),
  ].map { |slope| count_trees(forest, slope).to_i64 }.product
end

input = ARGF.gets_to_end
p! part1(input)
p! part2(input)
