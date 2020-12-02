using Combinatorics

function brute1(numbers)
    for nums in combinations(numbers, 2)
        if sum(nums) == 2020
            return prod(nums)
        end
    end
end

function brute2(numbers)
    for nums in combinations(numbers, 3)
        if sum(nums) == 2020
            return prod(nums)
        end
    end
end

function main()
    numbers = map(x -> parse(Int, x), readlines())
    println(brute1(numbers))
    println(brute2(numbers))
end

main()
