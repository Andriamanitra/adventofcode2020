input = ARGF.gets_to_end
numbers = input.split.map(&.to_i).sort
TARGET = 2020

# Part 1

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
a = numbers[left]
b = numbers[right]
puts "(Part 1)"
puts "#{a} + #{b} = #{a+b}"
puts "#{a} * #{b} = #{a*b}"
puts "Answer: #{a*b}" if a+b == TARGET
puts

# Part 2

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

puts "(Part 2)"
a, b, c = numbers.values_at(left, middle, right)
puts "#{a} + #{b} + #{c} = #{a+b+c}"
puts "#{a} * #{b} * #{c} = #{a*b*c}"
puts "Answer: #{a*b*c}" if a+b+c == TARGET
puts
