require "big"

def part1(input)
  joltages = input.lines.map(&.to_i)
  joltages << 0
  joltages.sort!
  one = 0
  three = 1 # the one at the end
  joltages.each_cons_pair { |a, b|
    if b - a == 1
      one += 1
    elsif b - a == 3
      three += 1
    end
  }
  one * three
end

def count_paths(joltages, a, b) : UInt64
  mid = joltages.select { |x| a < x < [a + 4, b].min }
  if b - a <= 3
    if mid.size == 0
      return 1_u64
    elsif mid.size == 1
      return 2_u64
    else
      return 4_u64
    end
  else
    valids = 0_u64
    1.upto(mid.size).each { |n|
      mid.each_combination(n) { |seq|
        a_seq_b = [a] + seq + [b]
        valids += 1 if a_seq_b.each_cons(2).all? { |(lo, hi)| hi - lo <= 3 }
      }
    }
    return valids
  end
  raise "count_paths function is broken"
end

def part2(input)
  joltages = input.lines.map(&.to_i)
  joltages << 0
  joltages.sort!

  # must_have will contain all adapters that are always part of the chain
  must_have = [0]
  must_have += joltages.each_cons(2)
    .select { |(a, b)| b - a == 3 }
    .to_a
    .flatten
    .push(joltages.max)
    .uniq!

  # Calculate how many different paths between each of the "must have"s
  subpath_choices = must_have.each_cons(2).map { |(a, b)|
    count_paths(joltages, a, b)
  }
  subpath_choices.product
end

input = ARGF.gets_to_end
p! part1(input)
p! part2(input)
