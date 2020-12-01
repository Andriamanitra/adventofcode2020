require "benchmark"

TARGET = 2020
input = ARGF.gets_to_end

def my_part1(input)
  numbers = input.split.map(&.to_i).sort

  left = 0
  right = numbers.size - 1
  while numbers[left] + numbers[right] != TARGET && left < right
    while numbers[left] + numbers[right] > TARGET
      right -= 1
    end
    while numbers[left] + numbers[right] < TARGET
      left += 1
    end
  end
  numbers[left] * numbers[right]
end

def my_part2(input)
  numbers = input.split.map(&.to_i).sort

  left = 0
  right = numbers.size - 1
  while numbers.values_at(left, left+1, right).sum > TARGET && left+1 < right
    right -= 1
  end
  while numbers.values_at(left, right-1, right).sum < TARGET && left < right-1
    left += 1
  end

  middle = left + 1
  while middle < right
    rem = TARGET - numbers[left]
    while numbers[middle] + numbers[right] > rem
      right -= 1
    end
    while numbers[middle] + numbers[right] < rem
      middle += 1
    end
    break if numbers.values_at(left, middle, right).sum == TARGET
    left += 1
    middle = left + 1
  end

  numbers.values_at(left, middle, right).product
end

def brute_part1(input)
  input.split.map(&.to_i).combinations(2).select{|x| x.sum == 2020}.[0].product
end

def brute_part2(input)
  input.split.map(&.to_i).combinations(3).select{|x| x.sum == 2020}.[0].product
end

abort "BUGS IN PART 1" if my_part1(input) != brute_part1(input)
abort "BUGS IN PART 2" if my_part2(input) != brute_part2(input)

Benchmark.ips{|x|
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
}
