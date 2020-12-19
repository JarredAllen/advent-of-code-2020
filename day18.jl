struct Sum
    left
    right
end

struct Product
    left::Union{Sum,Product,Int}
    right::Union{Sum,Product,Int}
end

function evaluate(expr::Sum)::Int
    evaluate(expr.left) + evaluate(expr.right)
end

function evaluate(expr::Product)::Int
    evaluate(expr.left) * evaluate(expr.right)
end

function evaluate(expr::Int)::Int
    expr
end

function parse_expr_a(s::AbstractString)::Union{Sum,Product,Int}
    if count(c -> c == '*' || c == '+', s) == 0
        return parse(Int, strip(s, ['(',')']))
    elseif s[end] == ')'
        balance = 1
        i = length(s)-1
        while i > 0
            if s[i] == '('
                balance -= 1
            elseif s[i] == ')'
                balance += 1
            end
            if balance == 0
                break
            end
            i -= 1
        end
        if balance != 0
            error("Unbalanced parens")
        end
        if i == 1
            return parse_expr_a(strip(s[begin+1:end-1]))
        end
        right = parse_expr_a(strip(s[i+1:end-1]))
        left = s[begin:i-1]
        plus_index = findlast(c -> c == '+', left)
        times_index = findlast(c -> c == '*', left)
        if times_index === nothing || (plus_index !== nothing && plus_index > times_index)
            return Sum(
                parse_expr_a(strip(left[begin:plus_index-1])),
                right
            )
        else
            return Product(
                parse_expr_a(strip(left[begin:times_index-1])),
                right
            )
        end
    else
        plus_index = findlast(c -> c == '+', s)
        times_index = findlast(c -> c == '*', s)
        if times_index === nothing || (plus_index !== nothing && plus_index > times_index)
            return Sum(
                parse_expr_a(strip(s[begin:plus_index-1])),
                parse_expr_a(strip(s[plus_index+1:end]))
            )
        else
            return Product(
                parse_expr_a(strip(s[begin:times_index-1])),
                parse_expr_a(strip(s[times_index+1:end]))
            )
        end
    end
end

function main()
    f = open(ARGS[1])
    lines = readlines(f)
    close(f)
    ans_a = 0
    for line ∈ lines
        # println("$line:")
        expr = parse_expr_a(strip(line))
        res = evaluate(expr)
        ans_a += res
        # println("$expr = $res")
    end
    println("Part A: $ans_a")
    # println("Part B: $ans_b")
end

main()
