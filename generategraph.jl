function writeGraph(size::Int)
    nodes = []
    edges = []

    for i in 1:size
        push!(nodes, string(i, ";"))

        for j in i + 1:size
            if j > i && rand() < 0.5 continue end

            push!(edges, string(i, " -- ", j, "\t[Weight=", trunc(Int, rand() * 900 ÷ 1 + 100), "];"))
        end
    end

    open("res/generated/[graph]-random-$size.dot", "w") do file
        write(file, "graph random-$size {\n")

        for n in nodes
            write(file, string("\t", size, "\n"))
        end

        for e in edges
            write(file, string("\t", e, "\n"))
        end

        write(file, "}\n")
    end
end

function generateGraph(size::Int, fillValue::Int, digraph::Bool)
    graph = fill(fillValue, size, size)
    for i in 1:size
        start = digraph ? 0 : i
        for j in start + 1:size
            if j > start && rand() < 0.5 continue end

            if digraph
                graph[i, j] = trunc(Int, rand() * 900 ÷ 1 + 100)
            else
                graph[i, j] = graph[j, i] = trunc(Int, rand() * 900 ÷ 1 + 100)
            end
        end
    end
    graph
end
