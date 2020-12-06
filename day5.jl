function get_seat_id(seat)::Int
    parse(Int, replace(replace(seat, r"F|L" => "0"), r"B|R" => "1"), base=2)
end

function main()
    f = open(ARGS[1])
    lines = readlines(f)
    close(f)
    ids = [get_seat_id(line) for line in lines]
    for i in 1:1022
        if !(i in ids) && (i-1 in ids) && (i+1 in ids)
            println("Answer: ", i)
        end
    end
end

main()
