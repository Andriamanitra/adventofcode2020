def part1(input)
  first, second = input.lines
  wait = first.to_i
  buses = second.split(",").reject("x").map(&.to_i)
  buses
    .map { |id| [id - (wait % id), id] }
    .min
    .product
end

def part2(input)
  buses = input.lines[1].split(",").map(&.to_i { 0 })
  offsets = Hash(Int32, Int32).new
  bmax = buses.max
  index_of_max = buses.index(bmax).not_nil!
  buses.each_with_index do |bus, idx|
    offsets[bus] = idx if bus != 0
  end

  i = bmax.to_i64 - index_of_max
  stride = bmax
  until offsets.all? { |(id, offset)| (i + offset) % id == 0 }
    i += stride
  end

  i
end

input = ARGF.gets_to_end

p! part1(input)
# p! part2(input)  # Too slow :(
