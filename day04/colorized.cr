require "colorize"

class Passport
  REQUIRED_FIELDS = %w(pid byr iyr eyr hgt hcl ecl)

  @@widths = Hash(String, Int32).new(5)

  def initialize(content : String)
    @fields = Hash(String, String).new { "" }
    content.split.each do |pair|
      key, value = pair.split(':')
      @fields[key] = value
      @@widths[key] = [value.size, @@widths[key]].max
    end
  end

  def has_required_fields?
    REQUIRED_FIELDS.all? { |required| @fields.has_key?(required) }
  end

  def valid_field?(key)
    case key
    when "byr"
      1920 <= @fields["byr"].to_i <= 2002
    when "iyr"
      2010 <= @fields["iyr"].to_i <= 2020
    when "eyr"
      2020 <= @fields["eyr"].to_i <= 2030
    when "hgt"
      self.valid_height?
    when "hcl"
      @fields["hcl"].matches?(/^#[0-9a-f]{6}$/)
    when "ecl"
      %w(amb blu brn gry grn hzl oth).includes?(@fields["ecl"])
    when "pid"
      @fields["pid"].matches?(/^[0-9]{9}$/)
    when "cid"
      true
    end
  end

  def valid_height?
    m = @fields["hgt"].match(/(?<height>[0-9]+)(?<unit>cm|in)/)
    return false unless m
    case m["unit"]
    when "cm"
      150 <= m["height"].to_i <= 193
    when "in"
      59 <= m["height"].to_i <= 76
    end
  end

  def valid?
    self.has_required_fields? && REQUIRED_FIELDS.all? { |key| self.valid_field?(key) }
  end

  def self.print_header
    puts REQUIRED_FIELDS.map { |key|
      key.center(@@widths[key])
    }.join(" │ ")
    puts REQUIRED_FIELDS.map { |key|
      "─" * @@widths[key]
    }.join("─┼─")
  end

  def pprint(header = false)
    Passport.print_header if header
    puts REQUIRED_FIELDS.map { |key|
      if REQUIRED_FIELDS.includes?(key) && !@fields.has_key?(key)
        " -".center(@@widths[key]).colorize.back(:red)
      else
        @fields[key].rjust(@@widths[key])
          .colorize(self.valid_field?(key) ? :green : :red)
      end
    }.join(" │ ")
  end
end

def parse_input(input)
  input.split("\n\n").map { |data| Passport.new(data) }
end

def part1(input)
  passports = parse_input(input)
  passports.count(&.has_required_fields?)
end

def part2(input)
  passports = parse_input(input)
  passports.count(&.valid?)
end

input = ARGF.gets_to_end

passports = parse_input(input)
Passport.print_header
passports.each(&.pprint)

p! part1(input)
p! part2(input)
