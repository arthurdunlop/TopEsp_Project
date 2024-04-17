using Random

function GenerateUniformGeneration(medium_Generation::Vector{Float64}, variation_Rate::Float64)
    u_t = (rand(300) .- 0.5) .*2
    delta_t = variation_Rate .* medium_Generation
    return medium_Generation .+ u_t .*delta_t
end