const MapA = Dict{Tuple{Int,Int,Int},Bool}
const MapB = Dict{Tuple{Int,Int,Int,Int},Bool}

function parse_map_a(input::AbstractString)::MapA
    out = MapA()
    for (i, line) in enumerate(split(input, "\n"))
        for (j, c) in enumerate(line)
            out[(i,j,0)] = (c == '#')
        end
    end
    out
end

function is_active_a(map::MapA, x::Int, y::Int, z::Int)::Bool
    haskey(map, (x,y,z)) && map[(x,y,z)]
end

function count_active_neighbors(map::MapA, x::Int, y::Int, z::Int)::Int
    count = 0
    for i ∈ x-1:x+1
        for j ∈ y-1:y+1
            for k ∈ z-1:z+1
                if i == x && j == y && k == z
                    continue
                end
                if is_active_a(map, i, j, k)
                    count += 1
                end
            end
        end
    end
    count
end

function run_cycle(input::MapA)::MapA
    out = MapA()
    for i ∈ (reduce(min, x for (x,y,z) ∈ keys(input))-1):(reduce(max, x for (x,y,z) ∈ keys(input))+1)
        for j ∈ (reduce(min, y for (x,y,z) ∈ keys(input))-1):(reduce(max, y for (x,y,z) ∈ keys(input))+1)
            for k ∈ (reduce(min, z for (x,y,z) ∈ keys(input))-1):(reduce(max, z for (x,y,z) ∈ keys(input))+1)
                neighbors = count_active_neighbors(input, i, j, k)
                if neighbors == 3 || neighbors == 2 && is_active_a(input, i, j, k)
                    out[(i,j,k)] = true
                end
            end
        end
    end
    out
end

function parse_map_b(input::AbstractString)::MapB
    out = MapB()
    for (i, line) in enumerate(split(input, "\n"))
        for (j, c) in enumerate(line)
            out[(i,j,0,0)] = (c == '#')
        end
    end
    out
end

function is_active_b(map::MapB, w::Int, x::Int, y::Int, z::Int)::Bool
    haskey(map, (w, x,y,z)) && map[(w, x,y,z)]
end

function count_active_neighbors(map::MapB, w::Int, x::Int, y::Int, z::Int)::Int
    count = 0
    for l ∈ w-1:w+1
        for i ∈ x-1:x+1
            for j ∈ y-1:y+1
                for k ∈ z-1:z+1
                    if i == x && j == y && k == z && l == w
                        continue
                    end
                    if is_active_b(map, l, i, j, k)
                        count += 1
                    end
                end
            end
        end
    end
    count
end

function run_cycle(input::MapB)::MapB
    out = MapB()
    for i ∈ (reduce(min, w for (w,x,y,z) ∈ keys(input))-1):(reduce(max, w for (w,x,y,z) ∈ keys(input))+1)
        for j ∈ (reduce(min, x for (w,x,y,z) ∈ keys(input))-1):(reduce(max, x for (w,x,y,z) ∈ keys(input))+1)
            for k ∈ (reduce(min, y for (w,x,y,z) ∈ keys(input))-1):(reduce(max, y for (w,x,y,z) ∈ keys(input))+1)
                for l ∈ (reduce(min, z for (w,x,y,z) ∈ keys(input))-1):(reduce(max, z for (w,x,y,z) ∈ keys(input))+1)
                    neighbors = count_active_neighbors(input, i, j, k, l)
                    if neighbors == 3 || neighbors == 2 && is_active_b(input, i, j, k, l)
                        out[(i,j,k, l)] = true
                    end
                end
            end
        end
    end
    out
end

function main()
    f = open(ARGS[1])
    lines = strip(read(f, String))
    close(f)
    map = parse_map_a(lines)
    for i in 1:6
        map = run_cycle(map)
    end
    # println(join(["$k" for k in keys(map)], "\n"))
    ans_a = length(map)
    map = parse_map_b(lines)
    for i in 1:6
        map = run_cycle(map)
    end
    # println(join(["$k" for k in keys(map)], "\n"))
    ans_b = length(map)
    println("Part A: $ans_a")
    println("Part B: $ans_b")
end

main()
