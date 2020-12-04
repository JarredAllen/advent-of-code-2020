function is_valid_a(passport)
    occursin("byr:", passport) && occursin("iyr:", passport) && occursin("eyr:", passport) && occursin("hgt:", passport) && occursin("hcl:", passport) && occursin("ecl:", passport) && occursin("pid:", passport)
end

function is_valid_b(passport)
    (occursin(r"byr:(19[2-9][0-9]|200[0-2])($|\n| )", passport)
      && occursin(r"iyr:(2020|201[0-9])($|\n| )", passport)
      && occursin(r"eyr:(202[0-9]|2030)($|\n| )", passport)
      && occursin(r"hgt:((59|6[0-9]|7[0-6])in|(1[5-8][0-9]|19[0-3])cm)($|\n| )", passport)
      && occursin(r"hcl:#[0-9a-f]{6}($|\n| )", passport)
      && occursin(r"ecl:(amb|blu|brn|gry|grn|hzl|oth)($|\n| )", passport)
      && occursin(r"pid:[0-9]{9}($|\n| )", passport)
    )
end

function main()
    f = open(ARGS[1])
    passports = split(read(f, String), "\n\n")
    close(f)
    count = 0
    for passport in passports
        if is_valid_b(passport)
            count += 1
        end
    end
    println("Answer: $count")
end

main()
