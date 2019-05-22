function nested_prims_parallel(g)
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