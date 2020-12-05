require "bit_array"
require "benchmark"
SEATS = 1024

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

# Unnecessary "optimization" :D
macro seat_to_id(s)
  sum = 0
  {{s}}.each_char_with_index { |ch, i|
    sum += (ch == 'B' || ch == 'R') ? 1 << (9 - i) : 0
  }
  sum
end

def alt_part1(input)
  input.each_line.max_of { |row|
    seat_to_id(row)
  }
end

def alt_part2(input)
  occupied = BitArray.new(SEATS)
  input.each_line { |row|
    occupied[seat_to_id(row)] = true
  }
  (1...SEATS).find { |seat| occupied[seat - 1] && !occupied[seat] }
end

input = ARGF.gets_to_end
p! part1(input)
p! alt_part1(input)
p! part2(input)
p! alt_part2(input)

Benchmark.ips do |x|
  x.report("original part1") { part1(input) }
  x.report("original part2") { part2(input) }
  x.report(%("optimized" part1)) { alt_part1(input) }
  x.report(%("optimized" part2)) { alt_part2(input) }
end
