struct SetMask
    newmask::String
end

struct SetMem
    address::Int
    value::Int
end

setmask_regex = r"^mask = ([01X]+)$"
setmem_regex = r"^mem\[([0-9]+)\] = ([0-9]+)$"

function parse_program(lines::Array{<:String,1})::Array{Union{SetMask,SetMem},1}
    out = []
    for line in lines
        setmask = match(setmask_regex, line)
        setmem = match(setmem_regex, line)
        if setmask !== nothing
            push!(out, SetMask(setmask.captures[1]))
        elseif setmem !== nothing
            push!(out, SetMem(parse(Int, setmem.captures[1]), parse(Int, setmem.captures[2])))
        else
            error("Did not match regex: \"$line\"")
        end
    end
    out
end

function apply_mask_a(mask::String, value::Int)::Int
    and_mask = parse(Int, replace(mask, "X" => "1"), base=2)
    or_mask = parse(Int, replace(mask, "X" => "0"), base=2)
    (value & and_mask) | or_mask
end

function apply_instruction_a!(mask::String, mem::Dict{Int,Int}, instruction::SetMem)::String
    masked = apply_mask_a(mask, instruction.value)
    mem[instruction.address] = masked
    # println("mem[$(instruction.value)] = $masked (from $(instruction.value))")
    mask
end

function apply_instruction_a!(::String, ::Dict{Int,Int}, instruction::SetMask)::String
    # println("mask = $(instruction.newmask)")
    instruction.newmask
end

function apply_program_a(program::Array{Union{SetMem,SetMask}})::Dict{Int,Int}
    mask = ""
    mem = Dict{Int,Int}()
    for instruction in program
        mask = apply_instruction_a!(mask, mem, instruction)
    end
    mem
end

function apply_mask_b(mask::AbstractString, value::Int)::Array{Int,1}
    if length(mask) == 0
        return [value]
    elseif mask[1] == '0'
        return apply_mask_b(SubString(mask, 2), value)
    elseif mask[1] == '1'
        return [x | 2^(length(mask)-1) for x in apply_mask_b(SubString(mask, 2), value)]
    elseif mask[1] == 'X'
        subres::Array{Int,1} = apply_mask_b(SubString(mask, 2), value)
        a::Array{Int,1} = [x | 2^(length(mask)-1) for x in subres]
        b::Array{Int,1} = [x & ~(2^(length(mask)-1)) for x in subres]
        return vec(hcat(a, b))
    else
        error("Bad mask: \"$mask\"")
    end
end

function apply_instruction_b!(mask::String, mem::Dict{Int,Int}, instruction::SetMem)::String
    addresses = apply_mask_b(mask, instruction.address)
    # println("From mask $mask and addr $(instruction.address)")
    # println("$addresses")
    for address in addresses
        mem[address] = instruction.value
    end
    mask
end

function apply_instruction_b!(::String, ::Dict{Int,Int}, instruction::SetMask)::String
    instruction.newmask
end

function apply_program_b(program::Array{Union{SetMem,SetMask}})::Dict{Int,Int}
    mask = ""
    mem = Dict{Int,Int}()
    for instruction in program
        mask = apply_instruction_b!(mask, mem, instruction)
    end
    mem
end

function main()
    f = open(ARGS[1])
    lines = readlines(f)
    close(f)
    program = parse_program(lines)
    # println(program)
    res = apply_program_a(program)
    ans_a = sum(values(res))
    res = apply_program_b(program)
    ans_b = sum(values(res))
    println("Part A: $ans_a")
    println("Part B: $ans_b")
end

main()
