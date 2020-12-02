def parseline(line)
  a, b, letter, password = line.split(/\W+/)
  return a.to_i, b.to_i, letter[0], password
end

def part1(input)
  input.split("\n", remove_empty: true).count{|line|
    a, b, letter, password = parseline(line)
    a <= password.count(letter) <= b
  }
end

def part2(input)
  input.split("\n", remove_empty: true).count{|line|
    a, b, letter, password = parseline(line)
    (password[a-1] == letter) ^ (password[b-1] == letter)
  }
end

input = ARGF.gets_to_end
p! part1(input)
p! part2(input)
