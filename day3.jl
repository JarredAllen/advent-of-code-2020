function count_collisions(grid, dx::Int, dy::Int)::Int
    x = y = 1
    num_collisions = 0
    while x <= lastindex(grid)
        if grid[x][y] == '#'
            println("Collision at ($x, $y)")
            num_collisions += 1
        else
            println("No collision at ($x, $y)")
        end
        x += dx
        y += dy
        if y > lastindex(grid[1])
            y -= lastindex(grid[1]) - firstindex(grid[1]) + 1
        end
    end
    return num_collisions
end

function main()
    f = open(ARGS[1])
    lines = readlines(f)
    close(f)
    a = count_collisions(lines, 1, 1)
    b = count_collisions(lines, 1, 3)
    c = count_collisions(lines, 1, 5)
    d = count_collisions(lines, 1, 7)
    e = count_collisions(lines, 2, 1)
    println("Answer: ", a*b*c*d*e)
end

main()
