using BenchmarkTools
using Statistics
using Dates

include("../src/util/Common.jl")

include("../src/algorithms/prims/vector/PrimsSequential.jl")
include("../src/algorithms/prims/vector/PrimsSequentialNodes.jl")
include("../src/algorithms/prims/vector/PrimsParallel.jl")
include("../src/algorithms/prims/vector/PrimsParallelNodes.jl")

function printResults(trial)
    dump(trial)

    println("min: ", minimum(trial))
    println("median: ", median(trial))
    println("mean: ", mean(trial))
    println("max: ", maximum(trial))

    println("total seconds: ", sum(trial.times) / 1e9)
    println("total samples: ", length(trial.times))
end

graph = parsegraph(ARGS[1])

println(now())

# sequential = @benchmark prims(graph) samples=50 seconds=120 evals=1

# println(now())
# printResults(sequential)
# println(now())

# sequentialNodes = @benchmark primsN(graph) samples=50 seconds=120 evals=1

# println(now())
# printResults(sequentialNodes)
# println(now())

# parallel = @benchmark primsP(graph) samples=50 seconds=120 evals=1

# println(now())
# printResults(parallel)
# println(now())

# parallelNodes = @benchmark primsPN(graph) samples=50 seconds=120 evals=1

# println(now())
# printResults(parallelNodes)
