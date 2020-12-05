def seat_ids(input)
  input.split.map { |row| row.chomp.tr("FBLR", "0101").to_i(2) }
end

def part1(input)
  seat_ids(input).max
end

def part2(input)
  seats = seat_ids(input)
  seats.find { |id| !seats.includes?(id + 1) && seats.includes?(id + 2) }.not_nil! + 1
rescue NilAssertionError
  "No solution"
end

input = ARGF.gets_to_end
p! part1(input)
p! part2(input)
