function validate_a(line)
    dash = findfirst(isequal('-'), line)
    lineend = findnext(isequal(' '), line, dash)
    min_substr = SubString(line, 1, dash - 1)
    min_count = parse(Int, min_substr)
    max_substr = SubString(line, dash + 1, lineend - 1)
    max_count = parse(Int, max_substr)
    letter = line[lineend + 1]
    password_begin = findnext(isequal(' '), line, lineend + 1)+1
    password = SubString(line, password_begin, lastindex(line))
    letter_count = count(c -> c == letter, collect(password))
    println("$letter_count, $letter from \"$password\"")
    return min_count <= letter_count <= max_count
end

function validate_b(line)
    dash = findfirst(isequal('-'), line)
    lineend = findnext(isequal(' '), line, dash)
    min_substr = SubString(line, 1, dash - 1)
    first_index = parse(Int, min_substr)
    max_substr = SubString(line, dash + 1, lineend - 1)
    second_index = parse(Int, max_substr)
    letter = line[lineend + 1]
    password_begin = findnext(isequal(' '), line, lineend + 1)+1
    password = SubString(line, password_begin, lastindex(line))
    return (password[first_index] == letter) != (password[second_index] == letter)
end

function main()
    f = open(ARGS[1])
    lines = readlines(f)
    numbers = Array{Int32}(undef, length(lines))
    count = 0
    for line in lines
        if validate_b(line)
            count += 1
        end
    end
    close(f)
    println("Answer: ", count)
end

main()
