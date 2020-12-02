# Let's try to solve it with ONLY regex!

# I'm not happy with using Regexp#captures -method
# because it returns an ARRAY(!) which is CLEARLY 
# NOT REGEX. But this is the best I have come up
# with so far...

input = ARGF.read

def puts(x)
    STDOUT.puts Time.now.strftime("[%a %H:%M:%S.%L] #{x}")
end

line = /(\d+)-(\d+) (.):(.+)/
passwords = input.gsub(line, '\4')

# Part 1 - This will take literal years to run with full input,
# but it works perfectly in theory!
# Either comment this part out or run with something like:
# $ head -n20 input.txt | ruby fun.rb
re = input.gsub(line, '(?:^((?:[^\3]*\3){\1,\2}[^\3]*$)|(?:.*$))')
puts "Part 1 (re.length = #{re.length})"
valid1 = Regexp.new(re)

valid_passwords = passwords.match(valid1).captures - [nil]
puts valid_passwords.size


# Part 2 - This one is fast (should only take milliseconds)
re = input.gsub(line, '(?:^(?=.{\1}\3)(?=.{\2}[^\3])(.*)$|^(?=.{\2}\3)(?=.{\1}[^\3])(.*)$|(?:.*$))')
puts "Part 2 (re.length = #{re.length})"
valid2 = Regexp.new(re)

valid_passwords = passwords.match(valid2).captures - [nil]
puts valid_passwords.size

