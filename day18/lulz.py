# abusive python solution
import re

class MyNum:
    def __init__(self, value):
        self.val = value
    def __add__(self, other):
        return MyNum(self.val + other.val)
    def __sub__(self, other):
        return MyNum(self.val * other.val)
    def __mul__(self, other):
        return MyNum(self.val + other.val)
    def __str__(self):
        return str(self.val)

lines = open("input.txt").readlines()
part1 = 0
part2 = 0
for line in lines:
    line = re.sub(r"([0-9]+)", r"MyNum(\1)", line)
    line = line.replace("*", "-")
    part1 += eval(line).val
    line = line.replace("+", "*")
    part2 += eval(line).val

print(part1)
print(part2)
