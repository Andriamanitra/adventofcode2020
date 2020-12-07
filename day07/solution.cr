record Edge, num : Int32, dest : String

def visit(graph, node : String, visited : Array(String))
  visited << node
  graph[node].each do |x|
    visit(graph, x, visited) unless x.in?(visited)
  end
  return visited
end

def part1(input)
  h = Hash(String, Array(String)).new { |asd, key| asd[key] = [] of String }
  input.lines.map { |line|
    bag, contents = line.split("s contain ")
    contents.scan(/(\w+ \w+ bag)/).map(&.captures).each do |inner|
      inner.each do |inner_bag|
        h[inner_bag] << bag unless inner_bag.nil?
      end
    end
  }
  visited = [] of String
  visit(h, "shiny gold bag", visited)
  visited.size - 1
end

def visit2(graph, node : String, acc = 0)
  graph[node].each do |edge|
    dest = edge.dest
    acc += edge.num + edge.num * visit2(graph, dest)
  end
  return acc
end

def part2(input)
  baghash = Hash(String, Array(Edge)).new { |h, key| h[key] = [] of Edge }
  input.lines.map { |line|
    bag, contents = line.split("s contain ")
    contents.scan(/([0-9]+) (\w+ \w+ bag)/).each do |mdata|
      num, innerbag = mdata.captures
      baghash[bag] << Edge.new(num.to_i, innerbag) unless num.nil? || innerbag.nil?
    end
  }
  visit2(baghash, "shiny gold bag")
end

input = ARGF.gets_to_end

p! part1(input)
p! part2(input)
