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


n = parse(Int64, ARGS[1])
m = n / 5

mstNodes = Set(1:5:n)
distances = []

for i in 1:n
    push!(distances, trunc(Int, rand() * 900 ÷ 1 + 100))
end

println(now())

# cheapestSeq = @benchmark cheapestNode(distances, mstNodes) samples=1000 seconds=120 evals=1

# println(now())

# cheapestSeqN = @benchmark cheapestNodeN(distances, mstNodes) samples=1000 seconds=120 evals=1

# println(now())

cheapestPar = @benchmark cheapestNodeP(distances, mstNodes) samples=1000 seconds=120 evals=1

println(now())

cheapestParN = @benchmark cheapestNodePN(distances, mstNodes) samples=1000 seconds=120 evals=1

println(now())

# printResults(cheapestSeq)
# printResults(cheapestSeqN)
printResults(cheapestPar)
printResults(cheapestParN)
