include("../../util/Common.jl")

function fws(g)
    graph = copy(g)

    len = 0
    if (length(graph) > 0)
        len = length(graph[1, :])
    end

    for k = 1:len
        for j = 1:len
            for i = 1:len
                if graph[i,k] == 0 || graph[k,j] == 0
                    # do nothing
                elseif graph[i,j] == 0
                    graph[i,j] = graph[i,k] + graph[k,j]
                elseif graph[i,j] > graph[i,k] + graph[k,j]
                    graph[i,j] = graph[i,k] + graph[k,j]
                end
            end
        end
    end

    return graph
end

# g = parsefloyd("/Users/lukethompson/dev/uni/751-Project/res/generated/[digraph]-random-1000.dot")
# @time fws(g)

