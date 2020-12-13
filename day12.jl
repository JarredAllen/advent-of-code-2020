@enum instruction_kind north south east west left right forward

struct Instruction
    kind::instruction_kind
    amount::Int
end

struct Position
    x::Int
    y::Int
    angle::Int
end

function parse_instruction(s::AbstractString)::Instruction
    Instruction(
        begin
            c = s[1]
            if c == 'N'
                north
            elseif c == 'S'
                south
            elseif c == 'E'
                east
            elseif c == 'W'
                west
            elseif c == 'L'
                left
            elseif c == 'R'
                right
            elseif c == 'F'
                forward
            else
                error("Did not recognize $c")
            end
        end,
        parse(Int, SubString(s, 2))
    )
end

function parse_instructions(lines::Array{<:AbstractString,1})::Array{Instruction}
    out = []
    for line in lines
        push!(out, parse_instruction(line))
    end
    out
end

# East is +x, North is +y, Left is ccw
function make_move_a(initial::Position, move::Instruction)::Position
    if move.kind == north
        Position(initial.x, initial.y+move.amount, initial.angle)
    elseif move.kind == east
        Position(initial.x+move.amount, initial.y, initial.angle)
    elseif move.kind == south
        Position(initial.x, initial.y-move.amount, initial.angle)
    elseif move.kind == west
        Position(initial.x-move.amount, initial.y, initial.angle)
    elseif move.kind == left
        Position(initial.x, initial.y, initial.angle+move.amount)
    elseif move.kind == right
        Position(initial.x, initial.y, initial.angle-move.amount)
    elseif move.kind == forward
        dx = move.amount * cosd(initial.angle)
        dy = move.amount * sind(initial.angle)
        Position(initial.x+dx, initial.y+dy, initial.angle)
    else
        error("Unknown move kind: $move")
    end
end
function make_moves_a(initial::Position, moves::Array{Instruction,1})::Position
    pos = initial
    for move in moves
        # print("$move: $pos --> ")
        pos = make_move_a(pos, move)
        # println("$pos")
    end
    pos
end

struct Coords
    x::Int
    y::Int
end

struct BPosition
    ship::Coords
    waypoint::Coords
end
#
# East is +x, North is +y, Left is ccw
function make_move_b(initial::BPosition, move::Instruction)::BPosition
    if move.kind == north
        BPosition(initial.ship, Coords(initial.waypoint.x, initial.waypoint.y+move.amount))
    elseif move.kind == east
        BPosition(initial.ship, Coords(initial.waypoint.x+move.amount, initial.waypoint.y))
    elseif move.kind == south
        BPosition(initial.ship, Coords(initial.waypoint.x, initial.waypoint.y-move.amount))
    elseif move.kind == west
        BPosition(initial.ship, Coords(initial.waypoint.x-move.amount, initial.waypoint.y))
    elseif move.kind == left
        amount = move.amount
        wpx = Int(cosd(amount)*initial.waypoint.x - sind(amount)*initial.waypoint.y)
        wpy = Int(cosd(amount)*initial.waypoint.y + sind(amount)*initial.waypoint.x)
        BPosition(initial.ship, Coords(wpx, wpy))
    elseif move.kind == right
        amount = move.amount
        wpx = Int(cosd(amount)*initial.waypoint.x + sind(amount)*initial.waypoint.y)
        wpy = Int(cosd(amount)*initial.waypoint.y - sind(amount)*initial.waypoint.x)
        BPosition(initial.ship, Coords(wpx, wpy))
    elseif move.kind == forward
        BPosition(Coords(initial.ship.x + initial.waypoint.x*move.amount, initial.ship.y + initial.waypoint.y*move.amount), initial.waypoint)
    else
        error("Unknown move kind: $move")
    end
end
function make_moves_b(initial::BPosition, moves::Array{Instruction,1})::BPosition
    pos = initial
    for move in moves
        # print("$move: $pos --> ")
        pos = make_move_b(pos, move)
        # println("$pos")
    end
    pos
end

get_distance(a::Position, b::Position)::Int = abs(a.x-b.x) + abs(a.y-b.y)
get_distance(a::Coords, b::Coords)::Int = abs(a.x-b.x) + abs(a.y-b.y)

function main()
    f = open(ARGS[1])
    lines = readlines(f)
    close(f)
    instructions = parse_instructions(lines)
    initial = Position(0, 0, 0)
    final = make_moves_a(initial, instructions)
    ans_a = get_distance(initial, final)
    initial = BPosition(Coords(0, 0), Coords(10, 1))
    final = make_moves_b(initial, instructions)
    ans_b = get_distance(initial.ship, final.ship)
    println("Part A: $ans_a")
    println("Part B: $ans_b")
end

main()
