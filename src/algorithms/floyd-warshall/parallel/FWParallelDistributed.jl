using Distributed
using SharedArrays

include("../../../util/Common.jl")

function fwParallelDistributed(g)
    graph = copy(g)

    len = 0
    if (length(graph) > 0)
        len = length(graph[1, :])
    end

    convert(SharedArray, graph)
    addprocs(4)

    for k = 1:len
        @sync @distributed for i = 1:len
            for j = 1:len
                ij = graph[i,j]
                ik = graph[i,k]
                kj = graph[k,j]

                assigned = false
                if ik == 0 || kj == 0
                    graph[i,j] = ij
                    assigned = true
                end
            
                if ij == 0 && !assigned
                    graph[i,j] = ik + kj
                    assigned = true
                end
            
                if (!assigned)
                    graph[i,j] = minimum([ij, ik + kj])
                end
            end
        end
    end

    rmprocs(workers())

    return graph
end