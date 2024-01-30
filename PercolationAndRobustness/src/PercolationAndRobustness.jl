module PercolationAndRobustness

using Graphs

function Configuration_Generator(N, tau, kappa)
    degree_Array = Int[]
    Each_degree_count = []
    for i in 1:N-1
        push!(Each_degree_count, (i)^(-tau) * exp(-i/kappa))
    end
    normalizer = N / sum(Each_degree_count) 
    Each_degree_count = floor.(Int, Each_degree_count .* normalizer)
    Each_degree_count[1] = Each_degree_count[1] + (N - sum(Each_degree_count))
    for i in 1:N-1
        counter = Each_degree_count[i]
        if counter != 0
            for j in 1:counter
                push!(degree_Array, i)
            end
        end
    end
    if isodd(sum(degree_Array))
        degree_Array[1] = degree_Array[1] + 1
    end
    graph = random_configuration_model(N, degree_Array)
    return graph
end

function Gaussian_Configuration_Generator(N, kappa)
    degree_Array = Int[]
    Each_degree_count = []
    for i in 1:N-1
        push!(Each_degree_count, exp(-i^2/kappa))
    end
    normalizer = N / sum(Each_degree_count) 
    Each_degree_count = floor.(Int, Each_degree_count .* normalizer)
    Each_degree_count[1] = Each_degree_count[1] + (N - sum(Each_degree_count))
    for i in 1:N-1
        counter = Each_degree_count[i]
        if counter != 0
            for j in 1:counter
                push!(degree_Array, i)
            end
        end
    end
    if isodd(sum(degree_Array))
        degree_Array[1] = degree_Array[1] + 1
    end
    graph = random_configuration_model(N, degree_Array)
    return graph
end

function Kmax_Cutoff(graph, kmax)
    degree_Array = degree(graph)
    initial_size = Graphs.size(graph)[1]
    removal_counter = Int(0)
    for i in eachindex(degree_Array)
        if degree_Array[i] >= kmax
            rem_vertex!(graph, i - removal_counter)
            removal_counter += 1
        end
    end
    final_size = Graphs.size(graph)[1]
    size_diff = initial_size - final_size
    return graph, size_diff
end

function large_component_size(graph)
    return maximum(length.(connected_components(graph)))
end

function component_size_distribution(graph)
    components_arr = length.(connected_components(graph))
    return components_arr
end

function random_remove(graph, q)
    for i in 1:Graphs.size(graph)[1]
        if rand()>=q
            rem_vertex!(graph, i)
        end
    end
    return graph
end
end # module PercolationAndRobustness
