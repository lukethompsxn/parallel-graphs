include("../src/util/Common.jl")
using LightGraphs
import LightGraphs.Parallel

function floyd()
    graph = SimpleDiGraph(parsefloyd("./res/generated/[digraph]-random-1000.dot"))
    print("Sequential")
    @time @sync LightGraphs.floyd_warshall_shortest_paths(graph)
    print("Parallel")
    @time @sync Parallel.floyd_warshall_shortest_paths(graph)
end

floyd()
