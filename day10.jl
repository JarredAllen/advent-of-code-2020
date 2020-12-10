function num_diffs(nums::Array{Int,1}, diff::Int)::Int
    count = 0
    for i in 2:lastindex(nums)
        if nums[i] - nums[i-1] == diff
            count += 1
        end
    end
    count
end

cache = Dict()
function num_arrangements(nums::Array{Int,1}, fromindex::Int=1)::Int
    if fromindex > lastindex(nums)
        return 0
    end
    if !haskey(cache, fromindex)
        ans = 0
        for i = fromindex+1:lastindex(nums)
            if nums[i] > nums[fromindex] + 3
                break
            end
            ans += num_arrangements(nums, i)
        end
        if fromindex == lastindex(nums)
            ans = 1
        end
        cache[fromindex] = ans
    end
    cache[fromindex]
end

function main()
    f = open(ARGS[1])
    lines = readlines(f)
    close(f)
    joltages = [parse(Int, s) for s in lines]
    sort!(joltages)
    insert!(joltages, 1, 0)
    push!(joltages, reduce(max, joltages)+3)
    ans_a = num_diffs(joltages, 1) * num_diffs(joltages, 3)
    println("Part A: $ans_a")
    ans_b = num_arrangements(joltages)
    println("Part B: $ans_b")
end

main()
