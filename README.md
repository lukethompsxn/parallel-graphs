# Parallelisation of Graph Algorithms in Julia

This project provides parallel graph algorithm implementations in Julia. To run any of the algorithms, please first install [Julia](https://julialang.org/downloads/). Once installed, launch into julia by running the executable, or alternatively launch julia from terminal `exec '/Applications/Julia-1.1.app/Contents/Resources/julia/bin/julia'` _Note: this is the path on macOS, linux and windows will be different._

### Algorithms
*Prims Algorithm (Sequential and Parallel)*
- Nested Implementation
- Vector Implementation
- Vector Implementation using Nodes

*Floyd-Warshall (Sequential and Parallel)*

### How to run an algorithm
- First, import common tools using `include("./src/util/Common.jl")` and the algorithm which you want, for example to import nested prims sequential you would run `include("./src/algorithms/prims/nested/PrimsSequential.jl")`
- Next, parse the graph using `parseprims(path)` for prims, or `parsefloyd(path)` for floyd. For example, for parsing a graph for prims algorithm, you would run `graph = parseprims("./res/graphs/[graph]-pipeline-1.dot")` 
- Next, to run the algorithm, check in the file for the function naming, but it usually goes like `[type]_[algorithm]_[sequential/parallel]_[special_versions]` eg `nested_prims_sequential(graph)`. For example to run nested prims sequential, you would run `mst = nested_prims_sequential(graph)`
- Finally, to write the graph, you use `writegraph(mst, [graph type: graph or digraph], [name])`, for example `writegraph(mst, "graph", "nested_prims_sequential")`
- Alternatively you can use the `run.jl` script via command line. The arguments it takes are the path to the dot file, algorithm name, type (for Prim's) and parallelisation (optional) via -p. e.g. `julia run.jl res/graphs/[graph]-pipeline-1.dot prims nodes`
### How to run the test suite
- To run the test suite, simply run `include("./test/TestRunner.jl")`. This will run all the tests for both prims algorithm, and the floyd-warshall algorithm. Each test which is run produces a "Test Pass" or "Test Fail" with indicative information on which test it refers to. At the end, it provides on overall of the number of failed tests vs the total number of tests. 
