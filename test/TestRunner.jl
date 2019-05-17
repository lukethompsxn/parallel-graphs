include("../src/util/Common.jl")
include("../src/algorithms/floyd-warshall/FWSequential.jl")

# <-- Prims Tests -->

# <-- Floyd Warshall Tests -->
function fwtests()
    parsedgraph = parsegraph("/Users/lukethompson/dev/uni/751-Project/res/graphs/[digraph]-simple-1.dot")
    # Sequential
    floydwarshall(parsedgraph)

    if verify("/Users/lukethompson/dev/uni/751-Project/out/[digraph]-floyd-warshall.dot", "/Users/lukethompson/dev/uni/751-Project/test/output/[digraph]-floyd-warshall-[digraph]-simple-1.dot")
        println("Tests Pass")
    else
        println("Tests Failed")
    end
    # Parallel

end

function verify(outputpath, testpath)
    output = nothing
    test = nothing

    open(outputpath) do file
        output = read(file, String)
    end

    open(testpath) do file
        test = read(file, String)
    end

    return output == test
end

fwtests()
