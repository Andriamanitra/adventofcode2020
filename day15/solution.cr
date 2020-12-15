def part1(input, target_turn = 2020)
  spoken = Hash(Int32, Int32).new
  turn = 0
  next_num = 0
  number = 0
  input.split(",") { |s|
    number = s.to_i
    turn += 1
    spoken[number] = turn
  }
  while turn < target_turn
    turn += 1
    number = next_num
    if spoken.has_key?(number)
      next_num = turn - spoken[number]
    else
      next_num = 0
    end
    spoken[number] = turn
  end
  number
end

def part2(input)
  part1(input, target_turn = 30_000_000)
end

input = ARGF.gets_to_end

p! part1(input)
p! part2(input)
