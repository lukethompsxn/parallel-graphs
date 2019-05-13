include("../../../util/Common.jl")

using BenchmarkTools
using Statistics

using Distributed
using SharedArrays

parsedgraph = parsegraph(ARGS[1])

function cheapestNode(d, mstNodes)
    mincost = typemax(UInt32)
    nodeInd = -1
    cheapest = @distributed min for i = 1:length(d)
        if !in(i, mstNodes)
            if d[i] < mincost
                mincost = d[i]
                nodeInd = i
            end
        end
        (mincost, nodeInd)
    end

    return cheapest[2]
end

function updateVector(newNode, mstNodes, d, addedBy, graph)
    @distributed for i = 1:length(graph[1,:])
        if !in(i, mstNodes) && graph[newNode, i] != -1 && graph[newNode, i] < d[i]
            d[i] = graph[newNode, i]
            addedBy[i] = newNode
        end
    end
end

function prims(g)
    graph = SharedArray(copy(g))

    len = 0
    if (length(graph) > 0)
        len = length(graph[1, :])
    end

    d = fill(typemax(UInt32), len)
    addedBy = fill(-1, len)
    mstNodes = Set()
    mst = fill(-1, len, len)

    d[1] = 0
    push!(mstNodes, 1)
    updateVector(1, mstNodes, d, addedBy, graph)

    addprocs(4)

    while length(mstNodes) != len
        print("we here at -> ")
        newNode = cheapestNode(d, mstNodes)
        push!(mstNodes, newNode)
        updateVector(newNode, mstNodes, d, addedBy, graph)
        print(length(mstNodes), "/", len, " : ", newNode, " = ")

        index = CartesianIndex(addedBy[newNode], newNode)
        mst[index[1], index[2]] = graph[index]
        mst[index[2], index[1]] = graph[index]

        println(length(mstNodes) != len)
    end

    return mst
end

using Dates

# mst = prims(parsedgraph)
# writegraph(mst, "graph", "prims-mst")

println(now())

a = @benchmark prims(parsedgraph) samples = 10000 seconds = 10

println(now())

dump(a)

println("min: ", minimum(a))
println("median: ", median(a))
println("mean: ", mean(a))
println("max: ", maximum(a))

println("total seconds: ", sum(a.times) / 1e9)
println("total samples: ", length(a.times))
