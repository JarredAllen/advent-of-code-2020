function parse_rules(rules)::Dict
    out = Dict{String, Array{Tuple{Int, AbstractString}, 1}}()
    for rule in rules
        rule = split(rule, " bags contain ")
        key = rule[1]
        value = []
        for inside in split(rule[2], ", ")
            inside = split(inside)
            if inside[1] == "no"
                break
            end
            number = parse(Int, inside[1])
            color = join(inside[2:lastindex(inside)-1], " ")
            push!(value, (number, color))
        end
        out[key] = value
    end
    out
end

containing_cache = Dict("shiny gold" => true)
function contains_shiny_gold(rules, color)
    if haskey(containing_cache, color)
        return containing_cache[color]
    end
    for (_, color) in rules[color]
        if contains_shiny_gold(rules, color)
            containing_cache[color] = true
            return true
        end
    end
    containing_cache[color] = false
    return false
end

counting_cache = Dict()
function count_inside(rules, color)
    if haskey(counting_cache, color)
        return counting_cache[color]
    end
    total = 1
    for (count, inner_color) in rules[color]
        total += count * count_inside(rules, inner_color)
    end
    println("$color contains $total in total")
    counting_cache[color] = total
end

function main()
    f = open(ARGS[1])
    lines = readlines(f)
    close(f)
    rules = parse_rules(lines)
    println(rules)
    count = 0
    for color in keys(rules)
        if color == "shiny gold"
            continue
        end
        if contains_shiny_gold(rules, color)
            println(color)
            count += 1
        end
    end
    println("Part A: $count")
    count = count_inside(rules, "shiny gold") - 1 # Subtract one because the outermost doesn't count
    println("Part B: $count")
end

main()
