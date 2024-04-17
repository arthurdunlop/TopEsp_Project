include("Domain.jl")

function Build_Discounted_FCFE_Collection(generation_Collection::Vector{Float64})
    discounted_FCFE_Objects::Vector{Discounted_FCFE_Object} = []
    date = now()
    numero_Periodos_Totais = length(generation_Collection) 
    for geracao in generation_Collection
        push!(discounted_FCFE_Objects, Discounted_FCFE_Object(Data = date, Numero_Periodos_Totais = numero_Periodos_Totais, Geracao = geracao))
        date += Dates.Month(1)
    end
    return discounted_FCFE_Objects
end

function Discount_FCFE_To_Present_Value(discounted_FCFE_Object::Discounted_FCFE_Object, discount_rate::Float64, time_period::Int64) 
    return discounted_FCFE_Object.FCFE / (1 + discount_rate) ^ time_period
end

function Calculate_Cash_Flow_Present_Value(discounted_FCFE_Objects::Vector{Discounted_FCFE_Object}, discount_rate::Float64)
    counter::Int16 = 1
    result::Float64 = 0
    while counter <= length(discounted_FCFE_Objects)
        discounted_value = Discount_FCFE_To_Present_Value(discounted_FCFE_Objects[counter], discount_rate, counter-1)
        result += discounted_value
        counter += 1
    end
    return result
end

function Calculate_UFV_Valuation(generation_Collection::Vector{Float64}, discount_rate::Float64)
    Calculate_Cash_Flow_Present_Value(Build_Discounted_FCFE_Collection(generation_Collection), discount_rate)
end