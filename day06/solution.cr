def part1(input)
  groups = input.split("\n\n")
  groups.map(&.split.join.chars.uniq.size).sum
end

def part2(input)
  groups = input.split("\n\n")
  groups.map { |group|
    group.split
      .map(&.chars.to_set)
      .reduce { |a, b| a & b }
      .size
  }.sum
end

input = ARGF.gets_to_end
p! part1(input)
p! part2(input)
