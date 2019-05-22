typeint = Int16

function parseprims(path::String)
    graph = nothing

    open(path) do file
        count = length(collect(eachmatch(r"[0-9]{1,};", read(file, String))))
        graph = fill(typemax(typeint), count, count)
    end

    return parsegraph(graph, typeint, path)
end

function parsefloyd(path::String)
    graph = nothing

    open(path) do file
        count = length(collect(eachmatch(r"[0-9]{1,};", read(file, String))))
        graph = Array{Union{typeint, Nothing}}(nothing, count, count)
    end

    return parsegraph(graph, typeint, path)
end

function parsegraph(graph, typeint, path::String)
    open(path) do file
        for line in eachline(file)
            if (occursin(" -> ", line)) # directed edge
                m = eachmatch(r"[0-9]{1,}", line)
                vals = collect(m)
                if (length(vals) == 3)
                    graph[parse(typeint, vals[1].match), parse(typeint, vals[2].match)] = parse(typeint, vals[3].match)
                end
            elseif (occursin(" -- ", line)) # undirected edge
                m = eachmatch(r"[0-9]{1,}", line)
                vals = collect(m)
                if (length(vals) == 3)
                    graph[parse(typeint, vals[1].match), parse(typeint, vals[2].match)] = parse(typeint, vals[3].match)
                    graph[parse(typeint, vals[2].match), parse(typeint, vals[1].match)] = parse(typeint, vals[3].match)
                end
            end
        end
        return graph
    end
end

function writegraph(graph::Array, type::String, graphname::String)
    relation = ""
    if (type == "graph")
        relation = "--"
    elseif (type == "digraph")
        relation = "->"
    end

    if !isdir("out")  mkdir("out") end
    open("./out/[$(type)]-$(graphname).dot", "w") do file
        write(file, "$(type) $(graphname) {\n")

        for index in CartesianIndices(graph)
            index = CartesianIndex(index[2], index[1]) # find better way so we dont need to swap these

            if (graph[index] != -1 && index[1] != index[2])
                weight = graph[index] != nothing ? graph[index] : "INF"
                write(file, "\t$(index[1]) $(relation) $(index[2])\t[Weight=$(weight)];\n")

                # dont need to represent the edge twice in graph
                if (type == "graph")
                    graph[index[2], index[1]] = -1
                end
            end
        end

        write(file, "}")
    end
end