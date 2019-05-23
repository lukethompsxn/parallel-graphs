include("../../util/Common.jl")

function fws(g)
    println("running sequential")
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
    if ik == nothing || kj == nothing
        return ij
    end

    if ij == nothing
        return ik + kj
    end

    return minimum([ij, ik + kj])
end



