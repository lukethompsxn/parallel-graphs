include("../../util/Common.jl")

# graph = parsegraph("C:/Users/gqiao/Documents/SoftEng/Part_IV/Sem1/751/Project/751-Project/res/graphs/[graph]-random-1.dot")
graph = parsegraph(ARGS[1])

len = 0
if (length(graph) > 0)
    len = length(graph[1, :])
end
nodes = Set(1:len)

mstnodes = Set()
mst = fill(-1, len, len)

push!(mstnodes, pop!(nodes))
while length(mstnodes) != len
    index = CartesianIndex(first(mstnodes), 1)
    val = graph[first(mstnodes), 1] #it would be much faster to just add them to a queue

    for node in mstnodes
        if minimum(graph[node, :]) < val
            index = CartesianIndex(node, argmin(graph[node, :]))
            val = minimum(graph[node, :])
        end
    end

    if (!in(index[2], mstnodes))
        push!(mstnodes, index[2])
        mst[index] = val
        mst[index[2], index[1]] = val
    end
    graph[index] = typemax(Int16)
end

writegraph(mst, "graph", "prims-mst")


