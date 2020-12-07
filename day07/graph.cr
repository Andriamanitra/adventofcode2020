# Very dirty code, I know, please don't judge :(
# Produces .dot file for graphviz:
# $ crystal run graph.cr -- input.txt > graph.dot
# $ dot -Tsvg graph.dot > graph.svg

record Edge, num : Int32, dest : String

COLORS = {
  "chartreuse" => "#7FFF00",
  "fuchsia"    => "#FF00FF",
  "lime"       => "#00FF00",
  "coral"      => "#FF7F50",
  "beige"      => "#F5F5DC",
  "white"      => "#FFFFFF",
  "crimson"    => "#DC143C",
  "maroon"     => "#800000",
  "indigo"     => "#4B0082",
  "tomato"     => "#FF6347",
  "blue"       => "#0000FF",
  "cyan"       => "#00FFFF",
  "tan"        => "#D2B48C",
  "salmon"     => "#FA8072",
  "plum"       => "#DDA0DD",
  "yellow"     => "#FFFF00",
  "bronze"     => "#CD7F32",
  "aqua"       => "#00FFFF",
  "lavender"   => "#E6E6FA",
  "brown"      => "#A52A2A",
  "turquoise"  => "#40E0D0",
  "black"      => "#000000",
  "gray"       => "#C0C0C0",
  "magenta"    => "#FF00FF",
  "gold"       => "#FFD700",
  "violet"     => "#EE82EE",
  "green"      => "#008000",
  "purple"     => "#800080",
  "orange"     => "#FFA500",
  "olive"      => "#808000",
  "silver"     => "#C0C0C0",
  "red"        => "#FF0000",
  "teal"       => "#008080",
}

def visit(graph, node : String, visited : Array(String))
  visited << node
  graph[node].each do |x|
    visit(graph, x, visited) unless x.in?(visited)
  end
  return visited
end

def visit(graph : Hash(String, Array(Edge)), node : String, visited : Array(String))
  visited << node
  graph[node].each do |x|
    visit(graph, x.dest, visited)
  end
  return visited
end

def get_visited(input)
  baghash = Hash(String, Array(String)).new { |h, key| h[key] = [] of String }
  input.lines.map { |line|
    bag, contents = line.split("s contain ")
    contents.scan(/\w+ \w+ bag/) do |match|
      if inner_bag = match[0]
        baghash[inner_bag] << bag
      end
    end
  }
  visited = [] of String
  visit(baghash, "shiny gold bag", visited)
  return visited
end

def make_graph(input)
  baghash = Hash(String, Array(Edge)).new { |h, key| h[key] = [] of Edge }
  input.lines.map { |line|
    bag, contents = line.split("s contain ")
    contents.scan(/([0-9]+) (\w+ \w+ bag)/).each do |mdata|
      num, innerbag = mdata.captures
      baghash[bag] << Edge.new(num.to_i, innerbag) unless num.nil? || innerbag.nil?
    end
  }
  return baghash
end

input = ARGF.gets_to_end

GOLD = "#FFD700"
visited = get_visited(input)
graph = make_graph(input)
nodes = input.split("\n", remove_empty: true).map { |x| x.split[0..1].join("\n") }
visited_part2 = visit(graph, "shiny gold bag", [] of String)

puts %(digraph G {
graph [nodesep=0.03 ranksep=1.5 size=25]
node [shape="box" width=0.05 height=0.05 margin="0.05,0.02" style=filled]
edge [fontsize=32]
"shiny\ngold" [fillcolor="#{GOLD}" shape="ellipse" fontsize=52]
)

nodes.each do |node|
  next if node == "shiny\ngold"
  known = (node.sub("\n", " ") + " bag").in?(visited) || (node.sub("\n", " ") + " bag").in?(visited_part2)
  color = COLORS[node.split[1]]? || "black"
  puts %("#{node}" [fillcolor="#{color}"])
end

graph.each do |container, edges|
  edges.each do |edge|
    src = container.rchop(" bag").split.join("\n")
    dest = edge.dest.rchop(" bag").split.join("\n")
    if container.in?(visited_part2) && edge.dest.in?(visited_part2)
      puts %("#{src}" -> "#{dest}" [penwidth=3 label=#{edge.num} color=red])
    elsif container.in?(visited) && edge.dest.in?(visited)
      puts %("#{src}" -> "#{dest}" [penwidth=3])
    else
      puts %("#{src}" -> "#{dest}" [color="#AAAAAA"])
    end
  end
end
puts "}"
