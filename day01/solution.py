import sys
import time

numbers = []

for line in sys.stdin:
    numbers.append(int(line))

t0 = time.time()

numbers.sort()
TARGET = 2020

# Part 1
left = 0
right = len(numbers) - 1
while numbers[left] + numbers[right] != TARGET:
    while numbers[left] + numbers[right] > TARGET:
        right -= 1
    while numbers[left] + numbers[right] < TARGET:
        left += 1
print(numbers[left] * numbers[right])

# Part 2
left = 0
middle = 1
right = len(numbers) - 1
maxright = right

while left + 1 < right:
    remaining = TARGET - numbers[left]
    middle = left + 1
    while middle < right:
        while numbers[middle] + numbers[right] < remaining:
            middle += 1
        while numbers[middle] + numbers[right] > remaining:
            right -= 1
        if numbers[left] + numbers[middle] + numbers[right] == TARGET:
            print(numbers[left] * numbers[middle] * numbers[right])
            print(f"Took {1000*(time.time()-t0):.2f} milliseconds")
            exit(0)
    left += 1
    right = maxright

print("Couldn't find a solution")
