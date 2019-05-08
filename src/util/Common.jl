# note: this is a draft testing implementation and will need to be brought in line with dot specification
function parsegraph(path::String)
    integer = Int16
    graph = []

    # fix implementation to not require reading file twice
    open(path) do file
        count = length(collect(eachmatch(r"[0-9]{1,};", read(file, String))))
        graph = fill(typemax(integer), count, count)
    end

    open(path) do file
        for line in eachline(file)
            if (occursin(" -> ", line)) # directed edge
                m = eachmatch(r"[0-9]{1,}", line)
                vals = collect(m)
                if (length(vals) == 3)
                    graph[parse(integer, vals[1].match), parse(integer, vals[2].match)] = parse(integer, vals[3].match)
                end
            elseif (occursin(" -- ", line)) # undirected edge
                m = eachmatch(r"[0-9]{1,}", line)
                vals = collect(m)
                if (length(vals) == 3)
                    graph[parse(integer, vals[1].match), parse(integer, vals[2].match)] = parse(integer, vals[3].match)
                    graph[parse(integer, vals[2].match), parse(integer, vals[1].match)] = parse(integer, vals[3].match)
                end
            end
        end
        return graph
    end
end

# note: this is a draft testing implementation and will need to be brought in line with dot specification
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

            if (graph[index] != -1)
                write(file, "\t$(index[1]) $(relation) $(index[2])\t[Weight=$(graph[index])];\n")

                # dont need to represent the edge twice in graph
                if (type == "graph")
                    graph[index[2], index[1]] = -1
                end
            end
        end

        write(file, "}")
    end
end