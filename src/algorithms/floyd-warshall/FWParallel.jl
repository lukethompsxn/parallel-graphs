include("../../util/Common.jl")

function fwp(g)
    return g
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



