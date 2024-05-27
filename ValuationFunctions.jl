include("Domain.jl")

function Build_Discounted_FCFE_Collection(generation_Collection::Vector{Float64})
    FCFE_Objects::Vector{FCFE_Object} = []
    date = now()
    numero_Periodos_Totais = length(generation_Collection)
    counter::Int64 = 1 
    for geracao in generation_Collection
        push!(FCFE_Objects, FCFE_Object(Index = counter, Data = date, Numero_Periodos_Totais = numero_Periodos_Totais, Geracao = geracao))
        date += Dates.Month(1)
        counter += 1
    end
    return FCFE_Objects
end

function Discount_FCFE_To_Present_Value(value_to_discount::Float64, discount_rate::Float64, time_period::Int64) 
    return value_to_discount / (1 + discount_rate) ^ time_period
end

function Aggregate_FCFE_To_Future_Value(value::Float64, discount_rate::Float64)
    return value * (1 + discount_rate)
end

function Calculate_Cash_Flow_Future_Value(FCFE_Objects::Vector{FCFE_Object}, discount_rate::Float64, fees_rate::Float64)
    counter::Int16 = 1
    caixa_Agregado::Float64 = 0
    divida::Float64 = 0
    while counter <= length(FCFE_Objects)
        future_value = Aggregate_FCFE_To_Future_Value(caixa_Agregado, discount_rate)
        fluxo_de_caixa = FCFE_Objects[counter].FCFE
        caixa_Agregado = future_value + fluxo_de_caixa + divida * (1 + fees_rate)
        if (caixa_Agregado <= 0)
            divida = caixa_Agregado
            caixa_Agregado = 0
        else
            divida = 0
        end
        counter += 1
    end
    if (caixa_Agregado > 0)
        return caixa_Agregado
    else
        return divida
    end
end

function Calculate_Cash_Flow_Present_Value(FCFE_Objects::Vector{FCFE_Object}, discount_rate::Float64)
    counter_::Int16 = 1
    result::Float64 = 0
    while counter_ <= length(FCFE_Objects)
        discounted_value = Discount_FCFE_To_Present_Value(FCFE_Objects[counter_].FCFE, discount_rate, counter_-1)
        result += discounted_value
        counter_ += 1
    end
    return result
end

function Calculate_UFV_Future_Valuation(generation_Collection::Vector{Float64}, discount_rate::Float64, fees_rate::Float64)
    Calculate_Cash_Flow_Future_Value(Build_Discounted_FCFE_Collection(generation_Collection), discount_rate, fees_rate)
end

function Calculate_UFV_Valuation(generation_Collection::Vector{Float64}, discount_rate::Float64)
    Calculate_Cash_Flow_Present_Value(Build_Discounted_FCFE_Collection(generation_Collection), discount_rate)
end