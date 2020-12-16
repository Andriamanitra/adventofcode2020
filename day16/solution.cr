def parse(input)
  sections = input.split("\n\n")

  valid_ranges = Hash(String, Array(Range(Int32, Int32))).new
  sections[0].each_line { |line|
    if m = line.match(/(?<name>[^:]+): (\d+)-(\d+) or (\d+)-(\d+)/)
      r = m.to_a[2..].map(&.not_nil!.to_i)
      valid_ranges[m["name"]] = [r[0]..r[1], r[2]..r[3]]
    else
      puts "fuck: #{line}"
    end
  }

  my_ticket = sections[1].lines[1].split(",").map(&.to_i)

  tickets = sections[2].lines[1..].map(&.split(",").map(&.to_i))

  {valid_ranges, my_ticket, tickets}
end

def part1(input)
  valid_ranges, _, tickets = parse(input)
  valids = Array.new(1000) { false }
  valid_ranges.each_value(&.each(&.each { |i| valids[i] = true }))
  tickets.sum(&.sum { |field| valids[field] ? 0 : field })
end

def part2(input)
  valid_ranges, my_ticket, tickets = parse(input)
  valids = Array.new(1000) { false }
  valid_ranges.each_value(&.each(&.each { |i| valids[i] = true }))
  tickets = tickets.select(&.all? { |field| valids[field] })
  field_count = my_ticket.size
  possibilities = valid_ranges.keys.map { |k|
    {
      k, (0...field_count).select { |i|
        tickets.all? { |ticket|
          ticket[i].in?(valid_ranges[k][0]) || ticket[i].in?(valid_ranges[k][1])
        }
      },
    }
  }.sort_by { |x| x[1].size }
  used = [] of Int32
  field_indices = possibilities.map_with_index { |(name, valids), i|
    field = (valids - used).first
    used << field
    {name, field}
  }.to_h
  field_indices.keys
    .select(&.starts_with?("departure"))
    .map { |field_name| my_ticket[field_indices[field_name]].to_u64 }
    .product
end

input = ARGF.gets_to_end

p! part1(input)
p! part2(input)
