function parsegraph(path::String)
    matrix = []

    open(path) do file
        count = length(collect(eachmatch(r"[0-9]{1,};", read(file, String))))
        matrix = fill(-1, count, count)
    end

    open(path) do file
        for line in eachline(file)
            if (occursin(" -> ", line))
                m = eachmatch(r"[0-9]{1,}", line)
                vals = collect(m)
                if (length(vals) == 3)
                    matrix[parse(Int8, vals[1].match), parse(Int8, vals[2].match)] = parse(Int8, vals[3].match)
                end
            end
        end
        return matrix
    end
end
