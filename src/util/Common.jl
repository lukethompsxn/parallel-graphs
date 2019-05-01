function parsegraph(path::String, type::String)
    integer = Int16
    matrix = []

    open(path) do file
        count = length(collect(eachmatch(r"[0-9]{1,};", read(file, String))))
        matrix = fill(typemax(integer), count, count)
    end

    open(path) do file
        for line in eachline(file)
            if (occursin(" -> ", line))
                m = eachmatch(r"[0-9]{1,}", line)
                vals = collect(m)
                if (length(vals) == 3)
                    matrix[parse(integer, vals[1].match), parse(integer, vals[2].match)] = parse(integer, vals[3].match)
                    if (type == "graph")
                        matrix[parse(integer, vals[2].match), parse(integer, vals[1].match)] = parse(integer, vals[3].match)
                    end
                end
            end
        end
        return matrix
    end
end

function writegraph(graph::Array, type::String)
end


