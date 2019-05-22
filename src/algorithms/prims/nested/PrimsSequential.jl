include("../../../util/Common.jl")

function nested_prims_sequential(g)
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
        val = graph[first(mstnodes), 1]

        for node in mstnodes
            for i = 1:length(graph[node,:])
                if graph[node,i] < val
                    index = CartesianIndex(node, i)
                    val = graph[node,i]
                end
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