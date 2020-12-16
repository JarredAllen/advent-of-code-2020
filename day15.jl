function play_game(starting::Array{Int,1}, len::Int)::Array{Int,1}
    memory = Dict{Int,Array{Int,1}}()
    out::Array{Int,1} = []
    for (i, num) in enumerate(starting)
        if !haskey(memory, num)
            memory[num] = [i]
        else
            push!(memory[num], i)
        end
        push!(out, num)
    end
    for i in length(out)+1:len
        if length(memory[out[end]]) == 1
            ans = 0
        else
            ans = memory[out[end]][end] - memory[out[end]][end-1]
        end
        push!(out, ans)
        if !haskey(memory, ans)
            memory[ans] = [i]
        else
            push!(memory[ans], i)
        end
    end
    out
end

function main()
    input = [16,12,1,0,15,7,11]
    seq = play_game(input, 30000000)
    ans_a = seq[2020]
    println("Part A: $ans_a")
    ans_b = seq[end]
    println("Part B: $ans_b")
end

main()
