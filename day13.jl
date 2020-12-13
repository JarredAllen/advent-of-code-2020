function get_earliest_bus(busses::Array{Int,1}, arrive_time::Int)::Tuple{Int,Int}
    first_time = 999999999
    first_bus = -1
    for bus in busses
        time::Int = ceil(arrive_time/bus)*bus
        if time < first_time
            first_time = time
            first_bus = bus
        end
    end
    (first_bus, first_time)
end

function chineseremainder(n::Array, a::Array)
    Π = prod(n)
    mod(sum(ai * invmod(Π ÷ ni, ni) * Π ÷ ni for (ni, ai) in zip(n, a)), Π)
end

function get_sequence_timestamp(line::String)::Int
    pairs = []
    for (i, x) in enumerate(split(line, ","))
        if x == "x"
            continue
        end
        x = parse(BigInt, x)
        push!(pairs, (x, x - ((i-1) % x)))
    end
    println(pairs)
    chineseremainder([pair[1] for pair in pairs], [pair[2] for pair in pairs])
end

function main()
    f = open(ARGS[1])
    lines = readlines(f)
    close(f)
    arrive_time = parse(Int, lines[1])
    busses = [parse(Int, x) for x in split(lines[2], ",") if x != "x"]
    bus_id, depart = get_earliest_bus(busses, arrive_time)
    ans_a = (depart-arrive_time) * bus_id
    ans_b = get_sequence_timestamp(lines[2])
    println("Part A: $ans_a")
    println("Part B: $ans_b")
end

main()
