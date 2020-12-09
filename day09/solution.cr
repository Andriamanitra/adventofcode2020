def part1(input)
  nums = input.lines.map(&.to_i64)
  nums[25..].zip(nums.each_cons(25)) { |target, prev25|
    if !prev25.find { |k| prev25.reject(k).includes?(target - k) }
      return target
    end
  }
end

def part2(input)
  target = part1(input) || 556543474 # in case part1() returns nil
  nums = input.lines.map(&.to_i64)
  nums.each_with_index { |start, start_idx|
    s = 0
    summed = nums[start_idx..].take_while { |x| s += x; s < target }
    return summed.minmax.sum if s == target
  }
end

input = ARGF.gets_to_end
p! part1(input)
p! part2(input)
