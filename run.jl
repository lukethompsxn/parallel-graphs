include("src/util/Common.jl")

include("src/algorithms/prims/vector/PrimsSequential.jl")
include("src/algorithms/prims/vector/PrimsParallel.jl")
include("src/algorithms/prims/vector/PrimsParallelNodes.jl")
include("src/algorithms/prims/vector/PrimsSequentialNodes.jl")
include("src/algorithms/floyd-warshall/FWSequential.jl")
include("src/algorithms/floyd-warshall/parallel/FWParallelThreads.jl")
include("src/algorithms/floyd-warshall/parallel/FWParallelDistributed.jl")

if length(ARGS) < 1
    println("Please specify graph to run algorithms on")
    exit()
end

graphName = ARGS[1]
if !isfile(graphName)
    println("File \"$graphName\" does not exist, please specify another graph file")
    exit()
end

if length(ARGS) > 1
    algorithm = ARGS[2]
    type = length(ARGS) > 2 ? ARGS[3] : nothing

    # assigns various settings or their defaults
    parallel = "-p" in ARGS

    if algorithm == "prims"
        graph = parseprims(graphName)
        if type == "nodes"
            if parallel
                output = vector_prims_parallel_nodes(copy(graph))
            else
                output = vector_prims_sequential_nodes(copy(graph))
            end
        else
            if parallel
                output = vector_prims_parallel(copy(graph))
            else
                output = vector_prims_sequential(copy(graph))
            end
        end
    elseif algorithm == "floyds"
        graph = parsefloyd(graphName)
        if parallel
            output = fwp(copy(graph))
        else
            output = fws(copy(graph))
        end
    else
        println("Please specify algorithm\n",
        "\tprims - minimum spanning tree\n",
        "\tfloyds - floyd-warshall all (shortest) path costs")
        exit()
    end
end

type = graphName[findfirst("[", graphName)[1] + 1 : findfirst("]", graphName)[1] - 1]
name = graphName[findfirst("-", graphName)[1] + 1 : findfirst(".", graphName)[1] - 1]

writegraph(output, type, name)