using BenchmarkTools
using Statistics
using Dates

include("../src/util/Common.jl")

# include("../src/algorithms/prims/vector/PrimsSequential.jl")
# include("../src/algorithms/prims/vector/PrimsSequentialNodes.jl")
# include("../src/algorithms/prims/vector/PrimsParallel.jl")
# include("../src/algorithms/prims/vector/PrimsParallelNodes.jl")
include("../src/algorithms/floyd-warshall/FWParallel.jl")
include("../src/algorithms/floyd-warshall/FWSequential.jl")

function printResults(trial)
    dump(trial)

    println("min: ", minimum(trial))
    println("median: ", median(trial))
    println("mean: ", mean(trial))
    println("max: ", maximum(trial))

    println("total seconds: ", sum(trial.times) / 1e9)
    println("total samples: ", length(trial.times))
end

graph = parsefloyd(ARGS[1])

# sequential = @benchmark fws(graph) samples=50 seconds=120 evals=1

start = now()
fws(graph)
println("sequential finished in ", now() - start)

start = now()
fwp(graph)
println("parallel finished in ", now() - start)

# sequentialNodes = @benchmark primsN(graph) samples=50 seconds=120 evals=1

# println(now())
# printResults(sequentialNodes)
# println(now())

# parallel = @benchmark fwp(graph) samples=50 seconds=120 evals=1



# parallelNodes = @benchmark primsPN(graph) samples=50 seconds=120 evals=1

# println(now())
# printResults(parallelNodes)
