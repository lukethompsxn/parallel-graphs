using Distributed
using SharedArrays

function cheapestNodePN(distanceVector, nodes)
    cheapest = @distributed min for i in collect(nodes)
        (distanceVector[i], i)
    end

    return cheapest[2]
end

function updateVectorPN(newNode, nodes, distanceVector, addedBy, graph)
    for i = 1:length(graph[1,:])
        if in(i, nodes) && graph[newNode, i] != -1 && graph[newNode, i] < distanceVector[i]
            distanceVector[i] = graph[newNode, i]
            addedBy[i] = newNode
        end
    end
end

function vector_prims_parallel_nodes(g)
    graph = g
    
    len = 0
    if (length(graph) > 0)
        len = length(graph[1, :])
    end
    
    addprocs(4)
    
    dist = fill(typemax(UInt32), len)
    addedBy = fill(-1, len)
    
    nodes = Set(1:len)
    mst = fill(-1, len, len)
    
    dist[1] = 0
    delete!(nodes, 1)

    updateVectorPN(1, nodes, dist, addedBy, graph)

    while length(nodes) > 0
        newNode = cheapestNodePN(dist, nodes)
        delete!(nodes, newNode)
        updateVectorPN(newNode, nodes, dist, addedBy, graph)

        index = CartesianIndex(addedBy[newNode], newNode)
        mst[index[1], index[2]] = graph[index]
        mst[index[2], index[1]] = graph[index]
    end

    rmprocs(workers())

    return mst
end
