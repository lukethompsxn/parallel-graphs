include("../src/util/Common.jl")
include("../src/algorithms/floyd-warshall/FWSequential.jl")
include("../src/algorithms/floyd-warshall/FWParallel.jl")
import Base.FileSystem

# <-- Prims Tests -->

# <-- Floyd Warshall Tests -->
function fwtests()
    for (root, dirs, files) in walkdir("res/digraphs/")
        for file in files
            # Sequential
            fws(parsegraph(("$(root)/$(file)")))
            verify("out/[digraph]-floyd-warshall.dot", "test/output/floyd-warshall/$(file)", "$(file) (Sequential)")

            # Parallel
            fwp(parsegraph(("$(root)/$(file)")))
            verify("out/[digraph]-floyd-warshall.dot", "test/output/floyd-warshall/$(file)", "$(file) (Parallel)")
        end
    end
end

function verify(outputpath, testpath, file)
    output = nothing
    test = nothing

    open(outputpath) do file
        output = read(file, String)
    end

    open(testpath) do file
        test = read(file, String)
    end

    if output == test
        println("Test Pass - $(file)")
    else
        println("Test Failure - $(file)")
    end
end

fwtests()
