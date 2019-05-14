using BenchmarkTools
using Statistics
using Dates

include("../src/util/Common.jl")

include("../src/algorithms/prims/vector/PrimsParallel.jl")
include("../src/algorithms/prims/vector/PrimsSequential.jl")

function printResults(trial)
    dump(trial)

    println("min: ", minimum(trial))
    println("median: ", median(trial))
    println("mean: ", mean(trial))
    println("max: ", maximum(trial))

    println("total seconds: ", sum(trial.times) / 1e9)
    println("total samples: ", length(trial.times))
end

mstNodes = Set()

n = parse(Int64, ARGS[1])
m = n / 5

for i in 1:m
    push!(mstNodes, trunc(Int, rand() * m ÷ 1) + 1)
end

distances = []

for i in 1:n
    push!(distances, trunc(Int, rand() * 900 ÷ 1 + 100))
end

println(now())

cheapestSeq = @benchmark cheapestNode(distances, mstNodes) samples=1000 seconds=30

println(now())

cheapestPar = @benchmark cheapestNodeP(distances, mstNodes) samples=1000 seconds=30

println(now())

printResults(cheapestSeq)
printResults(cheapestPar)
