struct Interval
    list::Array{Tuple{Int,Int},1}
end

function in_interval(interval::Interval, value::Int)::Bool
    for (lower, upper) in interval.list
        if lower <= value <= upper
            return true
        end
    end
    false
end

function parse_rules(rules_str::AbstractString)::Dict{String,Interval}
    rules = Dict()
    for line in split(rules_str, "\n")
        line = split(line, ": ")
        interval = Interval([
            begin
                parts = split(x, "-")
                (parse(Int, parts[1]), parse(Int, parts[2]))
            end
            for x in split(line[2], " or ")
        ])
        rules[String(line[1])] = interval
    end
    rules
end

const Ticket = Array{Int,1}

function parse_ticket(line::AbstractString)::Ticket
    [parse(Int, x) for x in split(line, ",")]
end

function is_ticket_valid(rules::Dict{String,Interval}, ticket::Ticket)::Union{Int,Nothing}
    for num ∈ ticket
        found = false
        for rule ∈ values(rules)
            if in_interval(rule, num)
                found = true
                break
            end
        end
        if !found
            return num
        end
    end
    nothing
end

function find_departure_indices(rules::Dict{String,Interval}, tickets::Array{Ticket,1})::Array{Int,1}
    possibilities = [Set([name for name in keys(rules)]) for _ ∈ 1:length(tickets[begin])]
    for ticket ∈ tickets
        for i ∈ 1:length(ticket)
            for name ∈ Set(possibilities[i])
                if !in_interval(rules[name], ticket[i])
                    filter!(x -> x != name, possibilities[i])
                end
            end
        end
    end
    filter_by_one_possibility_slots!(possibilities)
    # println(replace("$possibilities", "]), Set([" => "\n"))
    [i for i in 1:length(possibilities) if occursin(r"^departure", collect(possibilities[i])[1])]
end

function filter_by_one_possibility_slots!(guess::Array{Set{String},1})
    progress = true
    filtered = [false for p in guess]
    while progress
        progress = false
        for i ∈ 1:length(guess)
            if filtered[i]
                continue
            end
            if length(guess[i]) == 1
                filtered[i] = true
                progress = true
                value = collect(guess[i])[1]
                # println("Filtering for \"$value\"")
                for j ∈ 1:length(guess)
                    if j == i
                        continue
                    end
                    filter!(x -> x != value, guess[j])
                end
            end
        end
    end
end

function main()
    f = open(ARGS[1])
    parts = split(strip(read(f, String)), "\n\n")
    close(f)
    rules = parse_rules(parts[1])
    # println(rules)
    my_ticket = parse_ticket(split(parts[2], "\n")[2])
    valid_tickets::Array{Ticket,1} = []
    ans_a = 0
    for ticket in [parse_ticket(line) for line ∈ split(parts[3], "\n")[2:end]]
        num = is_ticket_valid(rules, ticket)
        if num === nothing
            push!(valid_tickets, ticket)
        else
            # println("$num: $ticket")
            ans_a += num
        end
    end
    println("Part A: $ans_a")
    depart_indices = find_departure_indices(rules, valid_tickets)
    ans_b = prod(my_ticket[i] for i in depart_indices)
    println("Part B: $ans_b")
end

main()
