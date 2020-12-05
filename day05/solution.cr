def seat_ids(input)
  input.split.map { |row| row.tr("FBLR", "0101").to_i(2) }
end

def part1(input)
  seat_ids(input).max
end

def part2(input)
  seats = seat_ids(input)
  seats.find { |id| !(id + 1).in?(seats) && (id + 2).in?(seats) }.not_nil! + 1
rescue NilAssertionError
  "No solution"
end

input = ARGF.gets_to_end
p! part1(input)
p! part2(input)
