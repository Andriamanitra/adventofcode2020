require "complex"

DIRECTIONS = {
  'N' => Complex.new(0, 1),
  'E' => Complex.new(1, 0),
  'S' => Complex.new(0, -1),
  'W' => Complex.new(-1, 0),
}

def part1(input)
  actions = input.lines.map { |line| {line[0], line[1..].to_i} }
  ship = Complex.new(0, 0)
  dirt = "ESWN".chars.cycle
  facing = dirt.next

  actions.each { |(a, n)|
    case a
    when .in?(DIRECTIONS.keys)
      ship += n * DIRECTIONS[a]
    when 'L'
      (4 - n//90).times { facing = dirt.next }
    when 'R'
      (n//90).times { facing = dirt.next }
    when 'F'
      ship += n * DIRECTIONS[facing]
    end
  }

  ship.real.abs + ship.imag.abs
end

def part2(input)
  actions = input.lines.map { |line| {line[0], line[1..].to_i} }
  ship = Complex.new(0, 0)
  waypoint = Complex.new(10, 1)

  actions.each { |(a, n)|
    if a.in?(DIRECTIONS.keys)
      waypoint += n * DIRECTIONS[a]
    elsif a == 'F'
      ship += n * waypoint
    elsif n == 180
      waypoint *= -1
    elsif (a == 'L' && n == 90) || (a == 'R' && n == 270)
      waypoint = Complex.new(-waypoint.imag, waypoint.real)
    else
      waypoint = Complex.new(waypoint.imag, -waypoint.real)
    end
  }

  ship.real.abs + ship.imag.abs
end

input = ARGF.gets_to_end

p! part1(input)
p! part2(input)
