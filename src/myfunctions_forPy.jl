using SimpleHypergraphs
using Graphs

using Pipe: @pipe


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

