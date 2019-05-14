include("../src/util/Common.jl")

include("../src/algorithms/prims/vector/PrimsParallelNodes.jl")

graph = parsegraph(ARGS[1])

mst = primsPN(graph)

writegraph(mst, "graph", ARGS[2])
