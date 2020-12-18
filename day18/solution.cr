require "string_scanner"

def parse(input)
  input.lines.map(&.gsub(/\s/, ""))
end

def evaluate(expr)
  scanner = StringScanner.new(expr)
  acc = scanner.scan(/[0-9]+/).not_nil!.to_i64
  until scanner.eos?
    operation = scanner.scan(/\*|\+/).not_nil!
    rvalue = scanner.scan(/[0-9]+/).not_nil!.to_i64
    if operation == "*"
      acc *= rvalue
    else
      acc += rvalue
    end
  end
  acc
end

def part1(input)
  parse(input).sum { |line|
    line
    while line.includes?("(")
      line = line.gsub(/\(([^\(\)]*)\)/) {
        evaluate($1)
      }
    end
    evaluate(line)
  }
end

input = ARGF.gets_to_end

p! part1(input)
