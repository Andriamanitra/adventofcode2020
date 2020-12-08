record Edge, num : Int32, dest : String

def visit(graph, node, visited = Set(String).new)
  visited << node
  graph[node].each do |x|
    visit(graph, x, visited) unless x.in?(visited)
  end
  return visited
end

def part1(input)
  baghash = Hash(String, Array(String)).new { |h, key| h[key] = [] of String }
  input.lines.map { |line|
    bag, contents = line.split("s contain ")
    contents.scan(/\w+ \w+ bag/) do |(inner_bag)|
      baghash[inner_bag] << bag
    end
  }
  visited = visit(baghash, "shiny gold bag")
  visited.size - 1
end

def count_inner(graph, node)
  graph[node].sum(0) { |edge|
    dest = edge.dest
    edge.num + edge.num * count_inner(graph, dest)
  }
end

def part2(input)
  baghash = Hash(String, Array(Edge)).new { |h, key| h[key] = [] of Edge }
  input.lines.map { |line|
    bag, contents = line.split("s contain ")
    contents.scan(/([0-9]+) (\w+ \w+ bag)/) { |(_, num, innerbag)|
      baghash[bag] << Edge.new(num.to_i, innerbag)
    }
  }
  count_inner(baghash, "shiny gold bag")
end

input = ARGF.gets_to_end

p! part1(input)
p! part2(input)
