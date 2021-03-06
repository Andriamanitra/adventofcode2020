require "bit_array"
require "benchmark"
SEATS = 1024

# Original versions
# - use tr (fairly slow)

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

# Original optimized versions
# - replace tr with simple if statement
# - fewer writes
# - replace function call with macro
# - use BitArray to represent each seat with only one bit (part 2)

macro seat_to_id(s)
  sum = 0
  {{s}}.each_char_with_index { |ch, i|
    sum += (ch == 'B' || ch == 'R') ? 1 << (9 - i) : 0
  }
  sum
end

def part1_opt(input)
  input.each_line.max_of { |line|
    seat_to_id(line)
  }
end

def part2_opt(input)
  occupied = BitArray.new(SEATS)
  input.each_line { |line|
    occupied[seat_to_id(line)] = true
  }
  (1...SEATS).find { |seat| occupied[seat - 1] && !occupied[seat] }
end

# Sorting versions
# - same seat_to_id macro as the optimized version
# - need to store intermediate results and sort them -> O(n log(n)), relatively slow
# - but the actual searching is fast

def part2_ss(input)
  seats = [] of Int32
  input.each_line { |line| seats << seat_to_id(line) }

  # Credit: straight-shoota
  seats.sort.each_cons(2, reuse: true).find { |(a, b)| a < b - 1 }.not_nil![0] + 1
end

def part2_bs(input)
  seats = [] of Int32
  input.each_line { |line| seats << seat_to_id(line) }

  seats.sort!
  first = seats[0]
  seats.bsearch_index { |x, i| x - first != i }.not_nil! + first
end

# Hash lookup for parsing
# - replace tr with a hash lookup (tiny bit faster)

# kevinsjoberg's seat_id() function
def seat_to_id3(boarding_pass)
  c_to_b = {'F' => 0, 'B' => 1, 'R' => 1, 'L' => 0}
  boarding_pass.each_char.reduce(0) { |acc, c| acc << 1 | c_to_b[c] }
end

def part2_ks(input)
  occupied = BitArray.new(SEATS)
  input.each_line { |line|
    occupied[seat_to_id3(line)] = true
  }
  (1...SEATS).find { |seat| occupied[seat - 1] && !occupied[seat] }
end

# Unsafe version
# - use BitArray to represent each seat with only one bit
# - use a pointer that advances by set number of bytes rather than #each_line
# - macro instead of function calls
# - Slice rather than String
# - replace tr with a bitwise magic (credit: tenebrousedge):
#    - F (0) = 1000(1)10
#    - B (1) = 1000(0)10
#    - L (0) = 1001(1)00
#    - R (1) = 1010(0)10
#    -> to map into bits: (~chr & 0b0100) >> 2

macro seat_from_ptr(ptr)
  {{ptr}}.to_slice(10).reduce(0){ |acc, x|
    (acc << 1) | ((~x & 0b0100) >> 2)
  }
end

def part2_unsafe(input)
  occupied = BitArray.new(SEATS)
  ptr = input.to_unsafe
  (0...(input.size / 11)).map { |i|
    occupied[seat_from_ptr((ptr + 11 * i))] = true
  }
  (1...SEATS).find { |seat| occupied[seat - 1] && !occupied[seat] }
end

# Expected sum version (nice one reddit)
# We can use the fact that expected sum of numbers from 0 to N is N*(N+1)/2
# to find the missing number without iterating over the whole set
# - only does one pass and keeps track of lowest, highest and sum
#   (no need to keep track of all seat ids)
def part2_expected_sum(input)
  low = SEATS
  high = 0
  total = 0
  input.each_line { |line|
    id = seat_to_id(line)
    if id < low
      low = id
    elsif id > high
      high = id
    end
    total += id
  }
  (((high + 1) * high) - ((low - 1) * low))//2 - total
end

def part2_expected_sum2(input)
  low = SEATS
  high = 0
  total = 0
  ptr = input.to_unsafe
  (0...(input.size / 11)).map { |i|
    id = seat_from_ptr((ptr + 11 * i))
    if id < low
      low = id
    elsif id > high
      high = id
    end
    total += id
  }
  (((high + 1) * high) - ((low - 1) * low))//2 - total
end

input = ARGF.gets_to_end
p! part1(input)
p! part1_opt(input)
p! part2(input)
p! part2_opt(input)
p! part2_ss(input)
p! part2_bs(input)
p! part2_ks(input)
p! part2_unsafe(input)
p! part2_expected_sum(input)
p! part2_expected_sum2(input)

# Part 1
puts "\n(Part 1) Benchmarks"
Benchmark.ips do |x|
  x.report("original") { part1(input) }
  x.report(%("optimized")) { part1_opt(input) }
end

# Part 2
puts "\n(Part 2) Benchmarks"
Benchmark.ips do |x|
  x.report("original") { part2(input) }
  x.report("hash instead of tr") { part2_ks(input) }
  x.report("sorting + search") { part2_ss(input) }
  x.report("sorting + bsearch") { part2_bs(input) }
  x.report(%["optimized" (BitArray)]) { part2_opt(input) }
  x.report("unsafe (+ BitArray)") { part2_unsafe(input) }
  x.report("expected sum") { part2_expected_sum(input) }
  x.report("unsafe expected sum") { part2_expected_sum2(input) }
end
