struct Nop
    arg::Int
end

struct Acc
    delta::Int
end

struct Jump
    offset::Int
end

function parse_instructions(lines::Array{String,1})::Array{Union{Nop,Acc,Jump}}
    code = []
    for line in lines
        line = split(line)
        instruction, arg = line[1], parse(Int, line[2])
        if instruction == "nop"
            item = Nop(arg)
        elseif instruction == "acc"
            item = Acc(arg)
        elseif instruction == "jmp"
            item = Jump(arg)
        else
            error("Unrecognized instruction: $instruction $arg")
        end
        push!(code, item)
    end
    code
end

function run_to_repeat(code::Array{Union{Nop,Acc,Jump}})::Int
    visited = Set()
    acc = 0
    pc = 1
    while true
        if pc in visited
            return acc
        end
        push!(visited, pc)
        if typeof(code[pc]) == Nop
            pc += 1
        elseif typeof(code[pc]) == Acc
            acc += code[pc].delta
            pc += 1
        elseif typeof(code[pc]) == Jump
            pc += code[pc].offset
        end
    end
end

function terminates(code::Array{Union{Nop,Acc,Jump}})::Union{Int,Nothing}
    visited = Set()
    acc = 0
    pc = 1
    while true
        if pc == lastindex(code)+1
            return acc
        end
        if pc in visited || pc > lastindex(code)
            return nothing
        end
        push!(visited, pc)
        if typeof(code[pc]) == Nop
            pc += 1
        elseif typeof(code[pc]) == Acc
            acc += code[pc].delta
            pc += 1
        elseif typeof(code[pc]) == Jump
            pc += code[pc].offset
        end
    end
end

function flip_nop_jmp(inst::Nop)::Jump
    Jump(inst.arg)
end
function flip_nop_jmp(inst::Jump)::Nop
    Nop(inst.offset)
end

function find_terminating(code::Array{Union{Nop,Acc,Jump}})::Int
    for i in 1:lastindex(code)
        if typeof(code[i]) == Acc
            continue
        end
        code[i] = flip_nop_jmp(code[i])
        res = terminates(code)
        if res !== nothing
            return res
        end
        code[i] = flip_nop_jmp(code[i])
    end
end

function main()
    f = open(ARGS[1])
    lines = readlines(f)
    close(f)
    code = parse_instructions(lines)
    # println(code)
    ans_a = run_to_repeat(code)
    println("Part A: $ans_a")
    ans_b = find_terminating(code)
    println("Part B: $ans_b")
end

main()
