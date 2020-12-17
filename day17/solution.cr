record Cube, x : Int32, y : Int32, z : Int32 = 0 do
  def each_neighbor(&block)
    [-1, 0, 1].repeated_permutations(3)
      .each { |(dx, dy, dz)|
        next if dx == dy == dz == 0
        yield Cube.new(x + dx, y + dy, z + dz)
      }
  end
end

record HyperCube, x : Int32, y : Int32, z : Int32 = 0, w : Int32 = 0 do
  def each_neighbor(&block)
    [-1, 0, 1].repeated_permutations(4)
      .each { |(dx, dy, dz, dw)|
        next if dx == dy == dz == dw == 0
        yield HyperCube.new(x + dx, y + dy, z + dz, w + dw)
      }
  end
end

alias CubeType = Cube | HyperCube

def parse(input, cubetype)
  active_cubes = Hash(CubeType, Bool).new(default_value: false)
  input.each_line.with_index { |line, y|
    line.each_char.with_index { |ch, x|
      active_cubes[cubetype.new(x, y)] = true if ch == '#'
    }
  }
  active_cubes
end

def next_state(active_cubes)
  cubes = active_cubes.class.new(default_value: false)

  active_neighbor_counts = Hash(CubeType, Int32).new(default_value: 0)
  active_cubes.keys.each(&.each_neighbor { |neighbor|
    active_neighbor_counts[neighbor] += 1
  })

  active_neighbor_counts.each { |cube, active_neighbors|
    if active_neighbors == 3
      cubes[cube] = true
    elsif active_neighbors == 2 && active_cubes[cube]
      cubes[cube] = true
    end
  }

  cubes
end

def part1(input)
  active_cubes = parse(input, Cube)
  6.times { active_cubes = next_state(active_cubes) }
  active_cubes.size
end

def part2(input)
  active_cubes = parse(input, HyperCube)
  6.times { active_cubes = next_state(active_cubes) }
  active_cubes.size
end

input = ARGF.gets_to_end

p! part1(input)
p! part2(input)
