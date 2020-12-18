enum Pos
  Floor
  Empty
  Occupied
  Invalid
end

# 2-d array-like data type that makes the edges unaccessible directly
#
# grid[x,y]
# ┌───────────🡪 +x
# │
# │
# 🡫 +y
#
# for example grid[0,0] corresponds to the element grid.grid[1][1] and
# grid[5,0] corresponds to the element grid.grid[1][6]

class Grid(T)
  property grid

  def initialize(@grid : Array(Array(T)))
  end

  def clone
    Grid(T).new(@grid.clone)
  end

  def width
    @grid.first.size - 2
  end

  def height
    @grid.size - 2
  end

  def xbounds
    0...width
  end

  def ybounds
    0...height
  end

  def []=(x : Int, y : Int, val : T)
    raise IndexError.new unless x.in?(xbounds) && y.in?(ybounds)
    @grid[y + 1][x + 1] = val
  end

  def [](x : Int, y : Int)
    raise IndexError.new unless x.in?(xbounds) && y.in?(ybounds)
    @grid[y + 1][x + 1]
  end

  def each_neighbor(x, y)
    [@grid[y][x],
     @grid[y][x + 1],
     @grid[y][x + 2],
     @grid[y + 1][x],
     @grid[y + 1][x + 2],
     @grid[y + 2][x],
     @grid[y + 2][x + 1],
     @grid[y + 2][x + 2],
    ].each
  end

  def each_with_index(&block)
    ybounds.each { |y|
      xbounds.each { |x|
        yield self[x, y], {x, y}
      }
    }
  end

  def content : Array(Array(T))
    @grid[1..height].map { |line| line[1..width] }
  end

  forward_missing_to @grid
end

def parse_grid(input : String)
  lines = input.lines
  width = lines.first.size + 2
  height = lines.size + 2

  grid = Array(Array(Pos)).new(height) { Array.new(width, Pos::Invalid) }
  lines.each_with_index { |row, ridx|
    row.each_char_with_index { |ch, cidx|
      if ch == 'L'
        grid[ridx + 1][cidx + 1] = Pos::Empty
      elsif ch == '.'
        grid[ridx + 1][cidx + 1] = Pos::Floor
      elsif ch == '#'
        grid[ridx + 1][cidx + 1] = Pos::Occupied
      else
        raise "yo wtf '#{ch}'"
      end
    }
  }
  Grid(Pos).new(grid)
end

def part1(input)
  grid = parse_grid(input)
  newgrid = grid.clone
  changing = true
  while changing
    changing = false
    grid.each_with_index { |val, (x, y)|
      next if val == Pos::Floor
      occupied = grid.each_neighbor(x, y).count(Pos::Occupied)
      if val == Pos::Empty && occupied == 0
        newgrid[x, y] = Pos::Occupied
        changing = true
      elsif val == Pos::Occupied && occupied > 3
        newgrid[x, y] = Pos::Empty
        changing = true
      else
        newgrid[x, y] = val
      end
    }
    grid, newgrid = newgrid, grid
  end
  grid.flatten.count(Pos::Occupied)
end

def part2(input)
  grid = parse_grid(input)
  newgrid = grid.clone
  changing = true
  while changing
    changing = false
    grid.each_with_index { |val, (x, y)|
      next if val == Pos::Floor
      directions = [
        {-1, -1}, {0, -1}, {1, -1},
        {-1, 0}, {1, 0},
        {-1, 1}, {0, 1}, {1, 1},
      ]
      occupied = directions.count { |(dx, dy)|
        seat = Pos::Invalid
        tmpx, tmpy = x + dx, y + dy
        while tmpx.in?(grid.xbounds) && tmpy.in?(grid.ybounds)
          seat = grid[tmpx, tmpy]
          if seat != Pos::Floor
            break
          end
          tmpx, tmpy = tmpx + dx, tmpy + dy
        end
        seat == Pos::Occupied
      }
      if val == Pos::Empty && occupied == 0
        newgrid[x, y] = Pos::Occupied
        changing = true
      elsif val == Pos::Occupied && occupied > 4
        newgrid[x, y] = Pos::Empty
        changing = true
      else
        newgrid[x, y] = val
      end
    }
    grid, newgrid = newgrid, grid
  end
  grid.flatten.count(Pos::Occupied)
end

input = ARGF.gets_to_end
p! part1(input)
p! part2(input)
