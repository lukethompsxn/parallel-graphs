include("../src/util/Common.jl")
include("../src/algorithms/floyd-warshall/FWSequential.jl")
include("../src/algorithms/floyd-warshall/FWParallelThreads.jl")
include("../src/algorithms/prims/nested/PrimsSequential.jl")
include("../src/algorithms/prims/nested/PrimsParallel.jl")
include("../src/algorithms/prims/vector/PrimsSequential.jl")
include("../src/algorithms/prims/vector/PrimsParallel.jl")
include("../src/algorithms/prims/vector/PrimsSequentialNodes.jl")
include("../src/algorithms/prims/vector/PrimsParallelNodes.jl")

failed = 0
total = 0
typeint = Int16

# <-- Prims Tests -->
function primstests()
    println("\n#### Testing Prims Algorithm ####")
    for (root, dirs, files) in walkdir("res/graphs/")
        for file in files
            # Nested Prims Sequential
            writegraph(nested_prims_sequential(parseprims(("$(root)/$(file)"))), "graph", "prims")
            verify("out/[graph]-prims.dot", "test/output/prims/$(file)", "$(file) (Nested Sequential)", "prims")

            # Nested Prims Parallel
            writegraph(nested_prims_parallel(parseprims(("$(root)/$(file)"))), "graph", "prims")
            verify("out/[graph]-prims.dot", "test/output/prims/$(file)", "$(file) (Nested Parallel)", "prims")

            # Vector Prims Sequential
            writegraph(vector_prims_sequential(parseprims(("$(root)/$(file)"))), "graph", "prims")
            verify("out/[graph]-prims.dot", "test/output/prims/$(file)", "$(file) (Vector Sequential)", "prims")

            # Vector Prims Parallel
            writegraph(vector_prims_parallel(parseprims(("$(root)/$(file)"))), "graph", "prims")
            verify("out/[graph]-prims.dot", "test/output/prims/$(file)", "$(file) (Vector Parallel)", "prims")

            # Vector Prims Sequential Nodes
            writegraph(vector_prims_sequential_nodes(parseprims(("$(root)/$(file)"))), "graph", "prims")
            verify("out/[graph]-prims.dot", "test/output/prims/$(file)", "$(file) (Vector Sequential Nodes)", "prims")

            # Vector Prims Parallel Nodes
            writegraph(vector_prims_parallel_nodes(parseprims(("$(root)/$(file)"))), "graph", "prims")
            verify("out/[graph]-prims.dot", "test/output/prims/$(file)", "$(file) (Vector Parallel Nodes)", "prims")
        end
    end
end

# <-- Floyd Warshall Tests -->
function fwtests()
    println("\n#### Testing Floyd Warshall Algorithm ####")
    for (root, dirs, files) in walkdir("res/digraphs/")
        for file in files
            # Sequential
            writegraph(fws(parsefloyd(("$(root)/$(file)"))), "digraph", "floyd-warshall")
            verify("out/[digraph]-floyd-warshall.dot", "test/output/floyd-warshall/$(file)", "$(file) (Sequential)", "floyd")

            # Parallel
            writegraph(fwp(parsefloyd(("$(root)/$(file)"))), "digraph", "floyd-warshall")
            verify("out/[digraph]-floyd-warshall.dot", "test/output/floyd-warshall/$(file)", "$(file) (Parallel)", "floyd")
        end
    end
end

function verify(outputpath, testpath, file, algorithm)
    output = nothing
    test = nothing

    open(outputpath) do file
        output = read(file, String)
    end

    open(testpath) do file
        test = read(file, String)
    end

    if Sys.iswindows()
        test = replace(test, r"\r\n?|\n" => "\n")
    end

    global total += 1

    if output == test
        println("Test Pass - $(file)")
    elseif algorithm == "prims"
        verifynodesandcost(outputpath, testpath, file)
    else
        println("Test Fail - $(file)")
        global failed += 1
    end
end

function verifynodesandcost(outputpath, testpath, file)
    outputnodes = Set()
    outputcost = 0
    answernodes = Set()
    answercost = 0

    open(outputpath) do file
        for line in eachline(file)
            if (occursin(" -- ", line))
                m = eachmatch(r"[0-9]{1,}", line)
                vals = collect(m)
                if (length(vals) == 3)
                    push!(outputnodes, parse(typeint, vals[1].match))
                    push!(outputnodes, parse(typeint, vals[2].match))
                    outputcost += parse(typeint, vals[3].match)
                end
            end
        end
    end

    open(testpath) do file
        for line in eachline(file)
            if (occursin(" -- ", line))
                m = eachmatch(r"[0-9]{1,}", line)
                vals = collect(m)
                if (length(vals) == 3)
                    push!(answernodes, parse(typeint, vals[1].match))
                    push!(answernodes, parse(typeint, vals[2].match))
                    answercost += parse(typeint, vals[3].match)
                end
            end
        end
    end

    if (outputcost == answercost && outputnodes == answernodes)
        println("Test Pass - $(file)")
    else
        println("Test Fail - $(file)")
        global failed += 1
    end
end


primstests()
fwtests()
println("\n##### RESULTS #####\n$(failed) tests failed out of $(total) tests")