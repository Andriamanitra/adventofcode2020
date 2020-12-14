MAX_BIT = 1_u64 << 35

# macro to print 36-bit numbers (stored as UInt64) in a nice way
macro b!(exp)
  puts("#{{{ exp.stringify }}.ljust(10)} = #{{{ exp }}.to_s(2).rjust(36, '0')}")
end

def part1(input)
  mem = Hash(UInt64, UInt64).new
  masked = 0_u64
  mask = 0_u64
  input.each_line do |line|
    case line
    when .match(/mask = ([01X]+)/)
      mask = $1.tr("X", "0").to_u64(2)
      masked = 0_u64
      $1.each_char_with_index { |ch, i|
        masked |= (MAX_BIT >> i) if ch != 'X'
      }
    when .match(/mem\[([0-9]+)\] = ([0-9]+)/)
      mem[$1.to_u64] = (~masked & $2.to_u64) | mask
    else
      raise "Unable to parse line: '#{line}'"
    end
  end
  mem.values.sum
end

def addresses(addr : UInt64, floating : Array(UInt64))
  firstfloat = floating.pop
  addr_t = addr | (1_u64 << firstfloat)
  addr_f = addr_t - (1_u64 << firstfloat)
  if floating.empty?
    [addr_t, addr_f]
  else
    addresses(addr_t, floating.clone) + addresses(addr_f, floating)
  end
end

def part2(input)
  mem = Hash(UInt64, UInt64).new
  floating = [] of UInt64
  mask = 0_u64
  input.each_line do |line|
    case line
    when .match(/mask = ([01X]+)/)
      # puts "mask #{$1}"
      mask = $1.tr("X", "0").to_u64(2)
      floating = $1.chars
        .map_with_index { |ch, i| 35_u64 - i if ch == 'X' }
        .compact
    when .match(/mem\[([0-9]+)\] = ([0-9]+)/)
      # puts "mem #{$1} #{$2}"
      m_addr = $1.to_u64 | mask
      addresses(m_addr, floating.clone).each { |addr| mem[addr] = $2.to_u64 }
    else
      raise "Unable to parse line: '#{line}'"
    end
  end
  # p! mem.size
  # mem.each { |key, value| puts "mem[#{key}]: #{value.to_s(2)} (#{value})" }
  mem.values.sum
end

input = ARGF.gets_to_end

p! part1(input)
p! part2(input)
