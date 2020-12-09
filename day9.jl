function is_sum_preceding_25(preceding::Array{Int}, target::Int)::Bool
    for i in preceding
        for j in preceding
            if i == j
                continue
            end
            if i+j == target
                return true
            end
        end
    end
    false
end

function find_first_invalid(numbers::Array{Int})::Int
    for i in 26:lastindex(numbers)
        if !is_sum_preceding_25(numbers[i-25:i-1], numbers[i])
            return numbers[i]
        end
    end
end

function find_subarray_sum_to(numbers::Array{Int}, target::Int)::Set{Int}
    for i in 1:lastindex(numbers)-1
        sum = numbers[i]
        for j in 1:lastindex(numbers)-i
            sum += numbers[i+j]
            if sum == target
                return Set(numbers[i:i+j])
            elseif sum > target
                break
            end
        end
    end
end

function main()
    f = open(ARGS[1])
    lines = readlines(f)
    close(f)
    numbers = [parse(Int, s) for s in lines]
    ans_a = find_first_invalid(numbers)
    println("Part A: $ans_a")
    seq_b = find_subarray_sum_to(numbers, ans_a)
    ans_b = reduce(min, seq_b) + reduce(max, seq_b)
    println("Part B: $ans_b")
end

main()
