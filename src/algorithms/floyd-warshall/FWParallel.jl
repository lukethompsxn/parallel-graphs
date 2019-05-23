include("../../util/Common.jl")

# Need to set JULIA_NUM_THREADS environment variable in the cmd window that opens julia.
# See: https://docs.julialang.org/en/v1.0/manual/environment-variables/#JULIA_NUM_THREADS-1

function fwp(g)
    println("running parallel with ", Threads.nthreads(), " threads")
    graph = copy(g)

    len = 0
    if (length(graph) > 0)
        len = length(graph[1, :])
    end

    for k = 1:len
        Threads.@threads for i = 1:len
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



