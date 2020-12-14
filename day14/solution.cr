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

def most_significant_bit(x : UInt64)
  # Fill all bits after MSB:
  x |= (x >> 1)
  x |= (x >> 2)
  x |= (x >> 4)
  x |= (x >> 8)
  x |= (x >> 16)
  x |= (x >> 32)
  # and now it's simple:
  x - (x >> 1)
end

def addresses(addr : UInt64, floating : UInt64)
  msb = most_significant_bit(floating)
  addr_t = addr | msb
  addr_f = addr_t - msb
  floating -= msb
  if floating == 0
    [addr_t, addr_f]
  else
    addresses(addr_t, floating) + addresses(addr_f, floating)
  end
end

def part2(input)
  mem = Hash(UInt64, UInt64).new
  floating = 0_u64
  mask = 0_u64
  input.each_line do |line|
    case line
    when .match(/mask = ([01X]+)/)
      mask = $1.tr("X", "0").to_u64(2)
      floating = 0_u64
      $1.chars.each_with_index { |ch, i|
        floating |= (MAX_BIT >> i) if ch == 'X'
      }
    when .match(/mem\[([0-9]+)\] = ([0-9]+)/)
      m_addr = $1.to_u64 | mask
      addresses(m_addr, floating).each { |addr| mem[addr] = $2.to_u64 }
    else
      raise "Unable to parse line: '#{line}'"
    end
  end
  mem.values.sum
end

input = ARGF.gets_to_end

p! part1(input)
p! part2(input)
