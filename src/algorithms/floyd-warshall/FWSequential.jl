include("../../util/Common.jl")

parsedgraph = parsegraph("/Users/lukethompson/dev/uni/751-Project/res/graphs/[digraph]-simple-1.dot")

function floydwarshall(g)
    graph = copy(g)

    len = 0
    if (length(graph) > 0)
        len = length(graph[1, :])
    end

    for k = 1:len
        for i = 1:len
            for j = 1:len
                graph[i,j] = update(graph[i,j], graph[i,k], graph[k,j])
            end
        end
    end

    writegraph(graph, "digraph", "floyd-warshall")
end

function update(ij, ik, kj)
    if ik == nothing || kj == nothing
        return ij
    end

    if ij == nothing
        return ik + kj
    end

    return minimum([ij, ik + kj])
end

floydwarshall(parsedgraph)


