REQUIRED_FIELDS = %w(byr iyr eyr hgt hcl ecl pid)

def parse_input(input)
  input
    .split("\n\n")
    .map do |passport|
      result = Hash(String, String).new
      passport.split.each do |pair|
        field, value = pair.split(':')
        result[field] = value if REQUIRED_FIELDS.includes?(field)
      end
      result
    end
end

def valid_height?(hgt)
  m = hgt.match(/(?<height>[0-9]+)(?<unit>cm|in)/)
  return false unless m
  case m["unit"]
  when "cm"
    150 <= m["height"].to_i <= 193
  when "in"
    59 <= m["height"].to_i <= 76
  end
end

def part1(input)
  passports = parse_input(input)
  passports.count { |passport| passport.keys.size == 7 }
end

def part2(input)
  passports = parse_input(input)
  passports.count do |passport|
    passport.keys.size == 7 &&
      1920 <= passport["byr"].to_i <= 2002 &&
      2010 <= passport["iyr"].to_i <= 2020 &&
      2020 <= passport["eyr"].to_i <= 2030 &&
      valid_height?(passport["hgt"]) &&
      passport["hcl"].matches?(/^#[0-9a-f]{6}$/) &&
      %w(amb blu brn gry grn hzl oth).includes?(passport["ecl"]) &&
      passport["pid"].matches?(/^[0-9]{9}$/)
  end
end

input = ARGF.gets_to_end
p! part1(input)
p! part2(input)
