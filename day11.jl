@enum Tile floor empty_seat occupied_seat

function count_occupied_neighbors(map::Array{Tile,2}, x::Int, y::Int)::Int
    count = 0
    for i in x-1:x+1
        for j in y-1:y+1
            if x == i && y == j || i < 1 || j < 1 || i > lastindex(map, 1) || j > lastindex(map, 2)
                continue
            end
            if map[i,j] == occupied_seat
                count += 1
            end
        end
    end
    # println("$x,$y:\t$count")
    count
end

function time_step_a(map::Array{Tile,2})::Array{Tile,2}
    out = []
    for j in 1:lastindex(map,2)
        for i in 1:lastindex(map,1)
            if map[i,j] == floor
                push!(out, floor)
            elseif map[i,j] == empty_seat
                if count_occupied_neighbors(map, i, j) == 0
                    push!(out, occupied_seat)
                else
                    push!(out, empty_seat)
                end
            else
                if count_occupied_neighbors(map, i, j) <= 3
                    push!(out, occupied_seat)
                else
                    push!(out, empty_seat)
                end
            end
        end
    end
    reshape(out, size(map))
end

function count_visible_occupied_seats(map::Array{Tile,2}, x::Int, y::Int)::Int
    count = 0
    for (dx, dy) in [(1,1), (1,0), (1,-1), (0,1), (0,-1), (-1,1), (-1,0), (-1,-1)]
        i = x+dx
        j = y+dy
        while i > 0 && j > 0 && i <= lastindex(map, 1) && j <= lastindex(map, 2)
            if map[i,j] != floor
                if map[i,j] == occupied_seat
                    count += 1
                end
                break
            end
            i += dx
            j += dy
        end
    end
    count
end

function time_step_b(map::Array{Tile,2})::Array{Tile,2}
    out = []
    for j in 1:lastindex(map,2)
        for i in 1:lastindex(map,1)
            if map[i,j] == floor
                push!(out, floor)
            elseif map[i,j] == empty_seat
                if count_visible_occupied_seats(map, i, j) == 0
                    push!(out, occupied_seat)
                else
                    push!(out, empty_seat)
                end
            else
                if count_visible_occupied_seats(map, i, j) <= 4
                    push!(out, occupied_seat)
                else
                    push!(out, empty_seat)
                end
            end
        end
    end
    reshape(out, size(map))
end

function produce_map(lines::Array{<:AbstractString,1})::Array{Tile,2}
    map = []
    for j in 1:lastindex(lines[1])
        for i in 1:lastindex(lines)
            c = lines[i][j]
            if c == '.'
                push!(map, floor)
            elseif c == 'L'
                push!(map, empty_seat)
            elseif c == '#'
                push!(map, occupied_seat)
            else
                error("Unrecognized character: '$c' in: $line")
            end
        end
    end
    reshape(map, (length(lines), Int(length(map)/length(lines))))
end

function map_to_string(map::Array{Tile,2})::String
    replace(
        replace(
            replace(
                replace(
                    replace(
                        "$map",
                        ";" => "\n"
                    ),
                    "floor" => "."
                ),
                "empty_seat" => "L"
            ),
            "occupied_seat" => "#"
        ),
        r"Tile\[|\]| " => ""
    )
end

function main()
    f = open(ARGS[1])
    lines = readlines(f)
    close(f)
    map = produce_map(lines)
    newmap = time_step_a(map)
    while !isequal(map, newmap)
        map = newmap
        newmap = time_step_a(map)
    end
    ans_a = count(i->i == occupied_seat, newmap)
    map = produce_map(lines)
    newmap = time_step_b(map)
    while !isequal(map, newmap)
        map = newmap
        # println("$(map_to_string(newmap))\n")
        newmap = time_step_b(map)
    end
    # println("$(map_to_string(newmap))\n")
    ans_b = count(i->i == occupied_seat, newmap)
    println("Part A: $ans_a")
    println("Part B: $ans_b")
end

main()
