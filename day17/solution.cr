record Cube, x : Int32, y : Int32, z : Int32 do
  def each_neighbor(&block)
    nrange = (-1..1)
    nrange.each { |nx|
      nrange.each { |ny|
        nrange.each { |nz|
          next if nx == 0 && ny == 0 && nz == 0
          yield Cube.new(x + nx, y + ny, z + nz)
        }
      }
    }
  end
end

def parse(input)
  active_cubes = Hash(Cube, Bool).new(default_value: false)
  input.each_line.with_index { |line, y|
    line.each_char.with_index { |ch, x|
      active_cubes[Cube.new(x, y, 0)] = true if ch == '#'
    }
  }
  active_cubes
end

def next_state(active_cubes)
  cubes = Hash(Cube, Bool).new(default_value: false)
  possible_cubes = [] of Cube
  active_cubes.keys.each { |active|
    possible_cubes << active
    active.each_neighbor { |neighbor|
      possible_cubes << neighbor
    }
  }
  possible_cubes.each { |cube|
    active_neighbor_count = 0
    cube.each_neighbor { |n| active_neighbor_count += 1 if active_cubes[n] }
    if active_cubes[cube]
      cubes[cube] = true if 2 <= active_neighbor_count <= 3
    else
      cubes[cube] = true if active_neighbor_count == 3
    end
  }

  cubes
end

def part1(input)
  active_cubes = parse(input)
  6.times do
    active_cubes = next_state(active_cubes)
  end
  active_cubes.size
end

input = ARGF.gets_to_end

p! part1(input)
