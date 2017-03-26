module Graphs

using StatsBase

export GraphVertex, NodeType, Person, Address,
       generate_random_graph, get_random_person, get_random_address, generate_random_nodes,
       convert_to_graph,
       bfs, check_euler, partition,
       graph_to_str, node_to_str,
       test_graph

type GraphVertex
  value
  neighbors ::Vector
end

abstract NodeType

type Person <: NodeType
  name
end


type Address <: NodeType
  streetNumber
end


N = 800
K = 10000

function generate_random_graph()
    A = Array{Int64,2}(N, N)

    for i=1:N, j=1:N
      A[i,j] = 0
    end

    for i in sample(1:N*N, K, replace=false)
      A[i] = 1
    end
    A
end

function get_random_person()
  Person(randstring())
end

function get_random_address()
  Address(rand(1:100))
end

function generate_random_nodes()
  nodes = Vector()
  for i= 1:N
    push!(nodes, rand() > 0.5 ? get_random_person() : get_random_address())
  end
  nodes
end

function convert_to_graph(A, nodes)
  N = length(nodes)
  push!(graph, map(n -> GraphVertex(n, GraphVertex[]), nodes)...)

  for i = 1:N, j = 1:N
      if A[i,j] == 1
        push!(graph[i].neighbors, graph[j])
      end
  end
end

function partition()
  parts = []
  remaining = Set(graph)
  visited = bfs(remaining=remaining)
  push!(parts, Set(visited))

  while !isempty(remaining)
    new_visited = bfs(visited=visited, remaining=remaining)
    push!(parts, new_visited)
  end
  parts
end

function bfs(;visited=Set(), remaining=Set(graph))
  first = next(remaining, start(remaining))[1]
  q = [first]
  push!(visited, first)
  delete!(remaining, first)
  local_visited = Set([first])

  while !isempty(q)
    v = pop!(q)

    for n in v.neighbors
      if !(n in visited)
        push!(q, n)
        push!(visited, n)
        push!(local_visited, n)
        delete!(remaining, n)
      end
    end
  end
  local_visited
end

function check_euler()
  if length(partition()) == 1
    return all(map(v -> iseven(length(v.neighbors)), graph))
  end
    "Graph is not connected"
end


function graph_to_str()
  graph_str = ""
  for v in graph
    graph_str *= "****\n"
    graph_str *= node_to_str(v.value)
    graph_str *= "Neighbors $(length(v.neighbors)):\n"
  end
  graph_str
end

function node_to_str(n)
  if isa(n, Person)
    "Person: $(n.name)\n"
  else isa(n, Address)
    "Street nr: $(n.streetNumber)\n"
  end
end

function test_graph()
  for i=1:100
    global graph = GraphVertex[]

    A = generate_random_graph()
    nodes = generate_random_nodes()
    convert_to_graph(A, nodes)

    str = graph_to_str()
    # println(str)
    println(check_euler())
  end
end

end
