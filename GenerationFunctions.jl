using Random
using Distributions
using Statistics

function GenerateUniformGeneration(medium_Generation::Vector{Float64}, variation_Rate::Float64)
    u_t = (rand(300) .- 0.5) .*2
    delta_t = variation_Rate .* medium_Generation
    return medium_Generation .+ u_t .*delta_t
end

function GenerateNormalGeneration(medium_Generation::Vector{Float64}, standard_deviation::Float64)
    generated_values = Vector{Float64}(undef, length(medium_Generation))
    for i in 1:length(medium_Generation)
        dist = Normal(medium_Generation[i], standard_deviation)
        generated_values[i] = rand(dist)
    end
    return generated_values
end

