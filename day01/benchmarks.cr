require "benchmark"

TARGET = 2020
input = ARGF.gets_to_end

def my_part1(input)
  numbers = input.split.map(&.to_i).sort

  left = 0
  right = numbers.size - 1
  while left < right
    while right > left && numbers[left] + numbers[right] > TARGET
      right -= 1
    end
    while left < right && numbers[left] + numbers[right] < TARGET
      left += 1
    end
    if numbers[left] + numbers[right] == 2020
      return numbers[left] * numbers[right]
    end
  end
  return nil
end

def my_part2(input)
  numbers = input.split.map(&.to_i).sort

  left = 0
  right = numbers.size - 1

  while numbers.values_at(left, right - 1, right).sum < TARGET
    left += 1
    return nil if left > right - 2
  end

  while numbers.values_at(left, left + 1, right).sum > TARGET
    right -= 1
    return nil if left > right - 2
  end
  maxright = right

  while left + 1 < right
    rem = TARGET - numbers[left]
    middle = left + 1
    while middle < right
      while numbers[middle] + numbers[right] < rem
        middle += 1
      end
      while numbers[middle] + numbers[right] > rem
        right -= 1
      end
      if numbers.values_at(left, middle, right).sum == TARGET
        return numbers.values_at(left, middle, right).product
      end
    end
    left += 1
    right = maxright
  end
  return nil
end

def brute_part1(input)
  input.split.map(&.to_i).combinations(2).select { |x| x.sum == 2020 }.[0].product
end

def brute_part2(input)
  input.split.map(&.to_i).combinations(3).select { |x| x.sum == 2020 }.[0].product
end

def smart_part1(input)
  set = Set(Int32).new
  input.each_line do |s|
    x = s.to_i
    if set.includes?(2020 - x)
      return x * (2020 - x)
    end
    set.add(x)
  end
end

abort "BUGS IN PART 1" unless my_part1(input) == brute_part1(input) == smart_part1(input)
abort "BUGS IN PART 2" unless my_part2(input) == brute_part2(input)

Benchmark.ips { |x|
  x.report("my solution (part 1)") {
    my_part1(input)
  }
  x.report("my solution (part 2)") {
    my_part1(input)
  }
  x.report("bruteforce (part 1)") {
    brute_part1(input)
  }
  x.report("bruteforce (part 2)") {
    brute_part2(input)
  }
  x.report("smart (part 1)") {
    smart_part1(input)
  }
}
