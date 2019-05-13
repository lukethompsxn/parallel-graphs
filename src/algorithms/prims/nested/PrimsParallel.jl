include("../../../util/Common.jl")

using BenchmarkTools
using Statistics

parsedgraph = parsegraph(ARGS[1])

function prims(g)
    graph = copy(g)

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
            min = minimum(graph[node, :])
            if  min < val
                index = CartesianIndex(node, argmin(graph[node, :]))
                val = min
            end
        end

        if (!in(index[2], mstnodes))
            push!(mstnodes, index[2])
            mst[index] = val
            mst[index[2], index[1]] = val
        end
        graph[index] = typemax(Int16)
    end
    return mst
end

using Dates

println(now())

a = @benchmark prims(parsedgraph) samples=10 seconds=300 gcsample=true

println(now())

# mst = prims(parsedgraph)
# writegraph(mst, "graph", "prims-mst")

dump(a)

println("min: ", minimum(a))
println("median: ", median(a))
println("mean: ", mean(a))
println("max: ", maximum(a))

println("total seconds: ", sum(a.times) / 1e9)
