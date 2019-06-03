using BenchmarkTools
using Statistics
using Dates

include("../src/util/Common.jl")

include("../src/algorithms/prims/vector/PrimsSequential.jl")
include("../src/algorithms/prims/vector/PrimsParallel.jl")
include("../src/algorithms/prims/vector/PrimsParallelNodes.jl")
include("../src/algorithms/prims/vector/PrimsSequentialNodes.jl")
include("../src/algorithms/floyd-warshall/FWSequential.jl")
include("../src/algorithms/floyd-warshall/parallel/FWParallelThreads.jl")
include("../src/algorithms/floyd-warshall/parallel/FWParallelDistributed.jl")

function printResults(trial, title)
    println("----------------------------------------\n$title\n")
    dump(trial)

    println("min: ", minimum(trial))
    println("median: ", median(trial))
    println("mean: ", mean(trial))
    println("max: ", maximum(trial))

    println("total seconds: ", sum(trial.times) / 1e9)
    println("total samples: ", length(trial.times))
end

if length(ARGS) < 1
    println("Please specify graph to run algorithms on")
    exit()
end

graphName = ARGS[1]

if length(ARGS) > 1
    algorithm = ARGS[2]
    type = length(ARGS) > 2 ? ARGS[3] : nothing

    # assigns various settings or their defaults
    numSamples = "-s" in ARGS ? parse(Int64, ARGS[findfirst(d -> d == "-s", ARGS) + 1]) : 30
    numSeconds = "-t" in ARGS ? parse(Int64, ARGS[findfirst(d -> d == "-t", ARGS) + 1]) : 300
    numEvals = "-e" in ARGS ? parse(Int64, ARGS[findfirst(d -> d == "-e", ARGS) + 1]) : 1

    if algorithm == "prims"
        graph = parseprims(graphName)

        if type == "nodes"
            println("Started benchmarking sequential prims: ", now())
            sequential = @benchmark vector_prims_sequential_nodes(copy(graph)) samples=numSamples seconds=numSeconds evals=numEvals
            println("Started benchmarking parallel prims: ", now())
            parallel = @benchmark vector_prims_parallel_nodes(copy(graph)) samples=numSamples seconds=numSeconds evals=numEvals
        else
            println("Started benchmarking sequential prims: ", now())
            sequential = @benchmark vector_prims_sequential(copy(graph)) samples=numSamples seconds=numSeconds evals=numEvals
            println("Started benchmarking parallel prims: ", now())
            parallel = @benchmark vector_prims_parallel(copy(graph)) samples=numSamples seconds=numSeconds evals=numEvals
        end
    elseif algorithm == "floyds"
        if type == nothing || type != "threads" && type != "distributed"
            println("Please specify parallel implementation\n\tthreads for @threads, distributed for @distributed")
            exit()
        end

        graph = parsefloyd(graphName)

        println("Started benchmarking sequential floyds: ", now())
        sequential = @benchmark fws(copy(graph)) samples=numSamples seconds=numSeconds evals=numEvals

        println("Started benchmarking parallel floyds: ", now())
        if type == "threads"
            parallel = @benchmark fwp(copy(graph)) samples=numSamples seconds=numSeconds evals=numEvals
        elseif type == "distributed"
            #output incorrect
            parallel = @benchmark fwParallelDistributed(copy(graph)) samples=numSamples seconds=numSeconds evals=numEvals
        end
    else
        println("Please specify algorithm\n",
        "\tprims - minimum spanning tree\n",
        "\tfloyds - floyd-warshall all (shortest) path costs")
        exit()
    end

    println("All benchmarks completed\n",
    "----------------------------------------\n",
    "\nResults\n")

    printResults(sequential, "Sequential")
    printResults(parallel, "Parallel")
else
    println("Started benchmarking sequential prims: ", now())
    sequential = @benchmark vector_prims_sequential_nodes(copy(graph)) samples=numSamples seconds=numSeconds evals=numEvals
    printResults(sequential, "Sequential")

    println("Started benchmarking parallel prims: ", now())
    parallel = @benchmark vector_prims_parallel_nodes(copy(graph)) samples=numSamples seconds=numSeconds evals=numEvals
    printResults(parallel, "Parallel")

    println("Started benchmarking sequential prims: ", now())
    sequential = @benchmark vector_prims_sequential(copy(graph)) samples=numSamples seconds=numSeconds evals=numEvals
    printResults(sequential, "Sequential")

    println("Started benchmarking parallel prims: ", now())
    parallel = @benchmark vector_prims_parallel(copy(graph)) samples=numSamples seconds=numSeconds evals=numEvals
    printResults(parallel, "Parallel")

    println("Started benchmarking sequential floyds: ", now())
    sequential = @benchmark fws(copy(graph)) samples=numSamples seconds=numSeconds evals=numEvals
    printResults(sequential, "Sequential")

    println("Started benchmarking parallel floyds threaded: ", now())
    parallel = @benchmark fwp(copy(graph)) samples=numSamples seconds=numSeconds evals=numEvals
    printResults(parallel, "Parallel")

    #output incorrect
    println("Started benchmarking parallel floyds distributed: ", now())
    parallel = @benchmark fwParallelDistributed(copy(graph)) samples=numSamples seconds=numSeconds evals=numEvals
    printResults(parallel, "Parallel")
end
