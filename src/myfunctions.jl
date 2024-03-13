using SimpleHypergraphs
using Graphs

using Pipe: @pipe

#################################################
using PyCall

py"""
import numpy as np


import random
def random_hypergraph_generation(n, m, max_weight):
    vertices_set = set()
    hypergraph_dict = {}
    for edge_id in range(m):
        edge_id = f"e{edge_id}"
        hypergraph_dict[edge_id] = {}
        for vertex_id in random.sample(range(n), random.choice(range(1, n + 1))):
            vertex_id = f"v{vertex_id}"
            # hypergraph_dict[edge_id][vertex_id] = random.choice(range(1,max_weight+1))
            hypergraph_dict[edge_id][vertex_id] = random.uniform(1, max_weight + 1)
            vertices_set.add(vertex_id)

    vertices_remapping = {}
    i = 0
    for vertex in vertices_set:
        vertices_remapping[vertex] = f"v{i}"
        i += 1

    for edge in hypergraph_dict.keys():
        temp_dict = {}
        for vertex in hypergraph_dict[edge]:
            temp_dict[vertices_remapping[vertex]] = hypergraph_dict[edge][vertex]
        hypergraph_dict[edge] = temp_dict

    vertices = sorted(
        list(
            set([vertex for edge in hypergraph_dict.values() for vertex in edge.keys()])
        )
    )
    ids_to_vertices_map = {}
    vertices_to_ids_map = {}
    i = 0
    while i < len(vertices):
        ids_to_vertices_map[i] = vertices[i]
        vertices_to_ids_map[vertices[i]] = i
        i += 1

    return hypergraph_dict, ids_to_vertices_map, vertices_to_ids_map

"""

###########################################################
###############################################
function get_index(st::String)
    num = Int[]
    for i in st
        try
            push!(num, parse(Int, i))
        catch
            #@show i
            nothing
        end
    end
    @pipe num |> join |> parse(Int, _)
end

##########################################


function Hypergraph(rhg::Tuple{Dict{Any,Any},Dict{Any,Any},Dict{Any,Any}})
    """ Takes as input the output of random_hypergraph_generation(n, m, max_weight) 
        Changew python's 0-based numbering to 1-based
    """
    nvert = length(rhg[2])
    nhedge = length(rhg[1])
    h = SimpleHypergraphs.Hypergraph{Float64}(nvert, nhedge)

    for (edg, dic) in rhg[1]
        i_hyper = get_index(edg) + 1
        println(i_hyper, " ---> h-edge $(edg)")

        for (v, weight) in dic
            i_vert = get_index(v) + 1
            @info " verttex $(i_vert) $v, weight $(weight) "

            h[i_vert, i_hyper] = weight

        end
    end

    h
end

########################################

