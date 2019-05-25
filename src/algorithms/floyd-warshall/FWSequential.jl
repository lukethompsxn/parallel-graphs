include("../../util/Common.jl")

function fws(g)
    graph = copy(g)

    len = 0
    if (length(graph) > 0)
        len = length(graph[1, :])
    end

    for k = 1:len
        for i = 1:len
            for j = 1:len
                graph[i,j] = update(graph[i,j], graph[i,k], graph[k,j])
            end
        end
    end

    return graph
end

function update(ij, ik, kj)
    if ik == 0 || kj == 0
        return ij
    end

    if ij == 0
        return ik + kj
    end

    return minimum([ij, ik + kj])
end



