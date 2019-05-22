function cheapestNodeN(d, nodes)
    min = typemax(UInt32)
    nodeInd = -1
    for i in nodes
        if d[i] < min
            min = d[i]
            nodeInd = i
        end
    end

    return nodeInd
end

# this can be parallelised with OMP principles
function updateVectorN(newNode, nodes, d, addedBy, graph)
    for i = 1:length(graph[1,:])
        if in(i, nodes) && graph[newNode, i] != -1 && graph[newNode, i] < d[i]
            d[i] = graph[newNode, i]
            addedBy[i] = newNode
        end
    end
end

function primsN(g)
    # graph = copy(g)
    graph = g

    len = 0
    if (length(graph) > 0)
        len = length(graph[1, :])
    end

    d = fill(typemax(UInt32), len)
    addedBy = fill(-1, len)
    nodes = Set(1:len)
    mst = fill(-1, len, len)

    d[1] = 0
    delete!(nodes, 1)
    updateVectorN(1, nodes, d, addedBy, graph)
    
    while length(nodes) > 0
        newNode = cheapestNodeN(d, nodes)
        delete!(nodes, newNode)
        updateVectorN(newNode, nodes, d, addedBy, graph)

        index = CartesianIndex(addedBy[newNode], newNode)
        mst[index[1], index[2]] = graph[index]
        mst[index[2], index[1]] = graph[index]
    end

    return mst
end
