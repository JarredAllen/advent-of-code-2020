function count_group(group)::Int
    everyone = []
    for line in split(group, "\n")
        seen = Set()
        for c in line
            push!(seen, c)
        end
        push!(everyone, seen)
    end
    all = intersect(everyone...)
    println(all)
    length(all)
end

function main()
    f = open(ARGS[1])
    groups = split(strip(read(f, String)), "\n\n")
    close(f)
    count = 0
    for group in groups
        count += count_group(group)
    end
    println("Answer: $count")
end

main()
