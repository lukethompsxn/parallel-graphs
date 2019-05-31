n = parse(Int64, ARGS[1])

nodes = []
edges = []

for i in 1:n
    push!(nodes, string(i, ";"))

    for j in i+1:n
        if j > i && rand() < 0.5 continue end

        push!(edges, string(i, " -- ", j, "\t[Weight=", trunc(Int, rand() * 900 ÷ 1 + 100), "];"))
    end
end

open("res/generated/[graph]-random-$n.dot", "w") do file
    write(file, "graph random-$n {\n")

    for n in nodes
        write(file, string("\t", n, "\n"))
    end

    for e in edges
        write(file, string("\t", e, "\n"))
    end

    write(file, "}\n")
end