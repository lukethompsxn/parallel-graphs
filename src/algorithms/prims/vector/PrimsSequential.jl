# this can be parallelised with OMP reduction
function cheapestNode(d, mstNodes)
    min = typemax(UInt32)
    nodeInd = -1
    for i = 1:length(d)
        if !in(i, mstNodes)
            if d[i] < min
                min = d[i]
                nodeInd = i
            end
        end
    end

    return nodeInd
end

# this can be parallelised with OMP principles
function updateVector(newNode, mstNodes, d, addedBy, graph)
    for i = 1:length(graph[1,:])
        if !in(i, mstNodes) && graph[newNode, i] != -1 && graph[newNode, i] < d[i]
            d[i] = graph[newNode, i]
            addedBy[i] = newNode
        end
    end
end

function prims(g)
    graph = copy(g)

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
    
    while length(mstNodes) != len
        newNode = cheapestNode(d, mstNodes)
        push!(mstNodes, newNode)
        updateVector(newNode, mstNodes, d, addedBy, graph)

        index = CartesianIndex(addedBy[newNode], newNode)
        mst[index[1], index[2]] = graph[index]
        mst[index[2], index[1]] = graph[index]
    end

    return mst
end
