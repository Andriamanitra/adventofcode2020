input = ARGF.gets_to_end
numbers = input.split.map(&.to_i).sort
TARGET = 2020

def part1(numbers)
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
      return numbers[left], numbers[right]
    end
  end
  return nil
end

def part2(numbers)
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
        return numbers.values_at(left, middle, right)
      end
    end
    left += 1
    right = maxright
  end
  return nil
end

puts "(Part 1)"
p1result = part1(numbers)
if p1result
  a, b = p1result
  puts "#{a} + #{b} = #{a + b}"
  puts "#{a} * #{b} = #{a*b}"
  puts "Answer: #{a*b}" if a + b == TARGET
  puts
else
  puts "Couldn't find a solution!"
end

puts "(Part 2)"
p2result = part2(numbers)
if p2result
  a, b, c = p2result
  puts "#{a} + #{b} + #{c} = #{a + b + c}"
  puts "#{a} * #{b} * #{c} = #{a*b*c}"
  puts "Answer: #{a*b*c}" if a + b + c == TARGET
  puts
else
  puts "Couldn't find a solution!"
end
