# import Pkg;
# Pkg.add("Distributions")
using Random
using Distributions
using Statistics

function GenerateUniformGeneration(medium_Generation::Vector{Float64}, variation_Rate::Float64)
    u_t = (rand(300) .- 0.5) .*2
    delta_t = variation_Rate .* medium_Generation
    return medium_Generation .+ u_t .*delta_t
end

function GenerateNormalGeneration(medium_Generation::Vector{Float64}, standard_deviation::Float64)
    dist = Normal(mean(medium_Generation), standard_deviation)
    return rand(dist, length(medium_Generation))
end