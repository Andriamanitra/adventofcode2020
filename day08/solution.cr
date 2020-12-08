enum IType
  Nop
  Acc
  Jmp
end

record SimpleInstruction, type : IType, number : Int32

# When new instructions get added, this becomes union type:
alias Instruction = SimpleInstruction

record State, ip : Int32, acc : Int32, instr : Instruction

class Program
  property instructions : Array(Instruction)
  property ip : Int32
  property acc : Int32
  property history : Array(State)

  def initialize(ip = 0, acc = 0)
    @instructions = [] of Instruction
    @ip = ip
    @acc = acc
    @history = [] of State
  end

  def current_instruction
    @instructions[@ip]
  end

  def execute
    t0 = Time.utc.to_unix_f
    while step == :RUNNING
      raise "Execution timed out!" if Time.utc.to_unix_f - t0 > 2
    end
    @acc
  end

  def execute(instruction : SimpleInstruction)
    @history << State.new(@ip, @acc, instruction)
    case instruction.type
    when IType::Nop
      @ip += 1
    when IType::Acc
      @acc += instruction.number
      @ip += 1
    when IType::Jmp
      @ip += instruction.number
    end
  end

  def load(code : Array(Instruction))
    @instructions = code
  end

  def load(code : String)
    load(Program.parse(code))
  end

  def step
    if 0 <= @ip < @instructions.size
      execute(@instructions[@ip])
      :RUNNING
    elsif ip < 0
      raise "Negative instruction pointer: #{@ip}"
    else
      :EXITED
    end
  end

  def self.parse(text : String)
    instructions = [] of SimpleInstruction
    text.each_line.with_index { |line, idx|
      first, _, rest = line.partition(' ')
      case cmd = IType.parse?(first)
      when .nil?
        STDERR.puts "WARNING: Skipping unknown instruction '#{first}' on line #{idx + 1}"
      when IType::Nop, IType::Acc, IType::Jmp
        instructions << SimpleInstruction.new(cmd, rest.to_i)
      else
        STDERR.puts "WARNING: Skipping unknown instruction '#{first}' on line #{idx + 1}"
      end
    }
    instructions
  end
end

def run_until_repeat(program)
  visited = Set(Int32).new
  until visited.includes?(program.ip)
    visited.add(program.ip)
    break if program.step == :EXITED
  end
  program.acc
end

def part1(input)
  program = Program.new
  code = Program.parse(input)
  program.instructions = code
  run_until_repeat(program)
  program.acc
end

def part2(input)
  code = Program.parse(input)
  program = Program.new
  program.instructions = code

  # Run the program once to gather all "nop" and "jmp"
  # instructions along the way
  run_until_repeat(program)

  program.history.each { |state|
    if state.instr.type == IType::Jmp
      mtype = IType::Nop
    elsif state.instr.type == IType::Nop
      mtype = IType::Jmp
    else
      next
    end
    modified = code.clone
    modified[state.ip] = SimpleInstruction.new(mtype, state.instr.number)
    program.instructions = modified
    program.ip = state.ip
    program.acc = state.acc
    run_until_repeat(program)
    return program.acc if program.step == :EXITED
  }
  "oops"
end

input = ARGF.gets_to_end
p! part1(input)
p! part2(input)
