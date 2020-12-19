struct LiteralRule
    c::Char
end

struct SequenceRule
    sequence::Array{Int,1}
end

struct OptionRule
    choice::Array{SequenceRule,1}
end

const Rule = Union{LiteralRule,SequenceRule,OptionRule}
const Rulebook = Dict{Int,Rule}

function parse_rule(rule::AbstractString)::Rule
    if occursin("\"", rule)
        LiteralRule(rule[findfirst(c -> c == '"', rule)+1])
    elseif occursin("|", rule)
        return OptionRule([parse_rule(strip(x)) for x in split(rule, "|")])
    else
        return SequenceRule([parse(Int, x) for x in split(rule)])
    end
end

function parse_rules(rules::AbstractString)::Rulebook
    out = Dict{Int,Rule}()
    for line in split(rules, '\n')
        line = split(line, ": ")
        out[parse(Int,line[1])] = parse_rule(line[2])
    end
    out
end

function compile_rule_to_regex(rules::Rulebook, rule::Union{Int,Rule}=0)::String
    if typeof(rule) == Int
        rule = rules[rule]
    end
    if typeof(rule) == LiteralRule
        return "$(rule.c)"
    elseif typeof(rule) == SequenceRule
        return join([compile_rule_to_regex(rules, rnum) for rnum in rule.sequence], "")
    elseif typeof(rule) == OptionRule
        # Special-case rules 8 and 11, because that allows me to still use regex
        if rule == rules[8]
            return "(" * compile_rule_to_regex(rules, 42) * ")+"
        elseif rule == rules[11]
            # The modified rule 11 is irregular.
            # However, it turns out that only going up to 8 layers deep is deep enough
            # to solve the given input.
            prefix = compile_rule_to_regex(rules, 42)
            suffix = compile_rule_to_regex(rules, 31)
            x = "(" * prefix * suffix * ")"
            for i ∈ 1:8
                x = "(" * prefix * x * "?" * suffix * ")"
            end
            return x
        else
            return "(" * join([compile_rule_to_regex(rules, rnum) for rnum in rule.choice], "|") * ")"
        end
    end
end

function main()
    f = open(ARGS[1])
    input = split(strip(read(f, String)), "\n\n")
    close(f)
    rules = parse_rules(input[1])
    # println(rules)
    rule_regex = Regex("^$(compile_rule_to_regex(rules))\$")
    # println("Regex: $rule_regex")
    ans_a = 0
    for message ∈ split(input[2], "\n")
        found = occursin(rule_regex, message)
        # println("\"$message\": $found")
        if found
            ans_a += 1
        end
    end
    rules[8] = parse_rule("42 | 42 8")
    rules[11] = parse_rule("42 31 | 42 11 31")
    rule_regex = Regex("^$(compile_rule_to_regex(rules))\$")
    println("Regex: $rule_regex")
    ans_b = 0
    for message ∈ split(input[2], "\n")
        found = occursin(rule_regex, message)
        println("\"$message\": $found")
        if found
            ans_b += 1
        end
    end
    println("Part A: $ans_a")
    println("Part B: $ans_b")
end

main()
