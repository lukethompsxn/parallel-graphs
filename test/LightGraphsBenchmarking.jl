include("../src/util/Common.jl")
using LightGraphs
using BenchmarkTools
using Statistics
using Dates
import LightGraphs.Parallel

function printresults(trial)
    dump(trial)

    println("min: ", minimum(trial))
    println("median: ", median(trial))
    println("mean: ", mean(trial))
    println("max: ", maximum(trial))

    println("total seconds: ", sum(trial.times) / 1e9)
    println("total samples: ", length(trial.times))
end

graph = SimpleDiGraph(parsefloyd("./res/generated/[digraph]-random-1000.dot"))

g1 = @sync copy(graph)
g2 = @sync copy(graph)

seq = @benchmark LightGraphs.floyd_warshall_shortest_paths(g1) samples=50 seconds=120 evals=1
par = @benchmark Parallel.floyd_warshall_shortest_paths(g2) samples=50 seconds=120 evals=1

println("Sequential Benchmarking...")
printresults(seq)
println("Parallel Benchmarking...")
printresults(par)