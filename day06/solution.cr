def part1(input)
  groups = input.split("\n\n")
  groups.sum(&.split.join.chars.uniq.size)
end

def part2(input)
  groups = input.split("\n\n")
  groups.sum { |group|
    group.split
      .map(&.chars.to_set)
      .reduce { |a, b| a & b }
      .size
  }
end

input = ARGF.gets_to_end
p! part1(input)
p! part2(input)
