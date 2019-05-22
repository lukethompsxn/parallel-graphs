using Distributed
using SharedArrays

function cheapestNodeP(distanceVector, mstNodes)
    mincost = typemax(UInt32)
    nodeInd = -1
    cheapest = @distributed min for i = 1:length(distanceVector)
        if !in(i, mstNodes)
            if distanceVector[i] < mincost
                mincost = distanceVector[i]
                nodeInd = i
            end
        end
        (mincost, nodeInd)
    end

    return cheapest[2]
end

function updateVectorP(newNode, mstNodes, distanceVector, addedBy, graph)
    @sync @distributed for i = 1:length(graph[1,:])
        if !in(i, mstNodes) && graph[newNode, i] != -1 && graph[newNode, i] < distanceVector[i]
            distanceVector[i] = graph[newNode, i]
            addedBy[i] = newNode
        end
    end
end

function vector_prims_parallel(g)
    graph = g
    
    len = 0
    if (length(graph) > 0)
        len = length(graph[1, :])
    end
    
    addprocs(4)
    
    dist = SharedArray(fill(typemax(UInt32), len))
    addedBy = SharedArray(fill(-1, len))
    
    mstNodes = Set()
    mst = fill(-1, len, len)
    
    dist[1] = 0
    push!(mstNodes, 1)
    updateVectorP(1, mstNodes, dist, addedBy, graph)

    while length(mstNodes) < len
        newNode = cheapestNodeP(dist, mstNodes)
        push!(mstNodes, newNode)
        updateVectorP(newNode, mstNodes, dist, addedBy, graph)

        index = CartesianIndex(addedBy[newNode], newNode)
        mst[index[1], index[2]] = graph[index]
        mst[index[2], index[1]] = graph[index]
    end

    return mst
end
