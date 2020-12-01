function expense_a(lst)
    for x in lst
        for y in lst
            if x + y == 2020
                return x*y
            end
        end
    end
end

function expense_b(lst)
    for x in lst
        for y in lst
            for z in lst
                if x + y + z == 2020
                    return x * y * z
                end
            end
        end
    end
end

function main()
    f = open(ARGS[1])
    lines = readlines(f)
    numbers = Array{Int32}(undef, length(lines))
    for i in 1:length(numbers)
        numbers[i] = parse(Int32, lines[i])
    end
    close(f)
    println("Answer: ", expense_b(numbers))
end

main()
