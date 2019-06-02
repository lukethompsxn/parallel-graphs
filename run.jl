using BenchmarkTools
primsPrl = "src/algorithms/prims/PrimsParallel.jl"
primsSeq = "src/algorithms/prims/vector/PrimsSequential.jl"

dijksPrl = "src/algorithms/dijkstra/DijkstraParallel.jl"
dijksSeq = "src/algorithms/dijkstra/DijkstraSequential.jl"

algorithm = ""
file = "res/graphs/generated/[graph]-random-1000.dot"

if isdefined(ARGS, 3) file = ARGS[3] end

if ARGS[1] == "prims"
    if ARGS[2] == "sequential"
        algorithm = primsSeq
    elseif ARGS[2] == "parallel"
        algorithm = primsPrl
    end
elseif ARGS[1] == "dijkstra"
    if ARGS[2] == "sequential"
        algorithm = dijksSeq
    elseif ARGS[2] == "parallel"
        algorithm = dijksPrl
    end
end

run(`julia $algorithm $file`)