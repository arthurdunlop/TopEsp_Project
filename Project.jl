using Dates

function Calculate_UFV_Valuation(generation_Collection::Vector{Float64}, discount_rate::Float64)
    Calculate_Cash_Flow_Present_Value(Build_Discounted_FCFE_Collection(generation_Collection), discount_rate)
end

Base.@kwdef struct Discounted_FCFE_Object

    Data::DateTime
    Numero_Periodos_Totais::Int16
    
    #Properties for FCFE workflow
    Geracao::Float64
    Tarifa_Liquida::Float64 = 720.0
    Receita_Bruta::Float64 = Tarifa_Liquida * Geracao
    Impostos_Diretos::Float64 = (0.0365 * Receita_Bruta) + 9670.0
    Receita_Liquida::Float64 = Receita_Bruta - Impostos_Diretos
    OPEX::Float64 = 13955.85
    EBITDA::Float64 = Receita_Liquida - OPEX
    Depreciacao::Float64 = 2815000.0 / Numero_Periodos_Totais
    EBT::Float64 = EBITDA - Depreciacao
    Imposto_Renda::Float64 = Receita_Bruta * 0.34 * 0.32
    CAPEX::Float64 = Calculate_CAPEX(Data)
    FCFE::Float64 = EBT - Imposto_Renda + Depreciacao - CAPEX

end

function Calculate_CAPEX(date::DateTime)
    if (month(date) = month(now()))
        return 3850412.0
    end
    return 0
end

function Build_Discounted_FCFE_Collection(generation_Collection::Vector{Float64})
    discounted_FCFE_Objects::Vector{Discounted_FCFE_Object} = []
    date = now()
    numero_Periodos_Totais = count(generation_Collection) 
    for geracao in generation_Collection
        push!(discounted_FCFE_Objects, Discounted_FCFE_Object(Data = date, Numero_Periodos_Totais = numero_Periodos_Totais, Geracao = geracao))
        date += month(1)
    end
    return discounted_FCFE_Objects
end

function Discount_FCFE_To_Present_Value(discounted_FCFE_Object::Discounted_FCFE_Object, discount_rate::Float64, time_period::Int16) 
    return discounted_FCFE_Object.FCFE / (1 + discount_rate) ^ time_period
end

function Calculate_Cash_Flow_Present_Value(discounted_FCFE_Objects::Vector{Discounted_FCFE_Object}, discount_rate::Float64)
    counter::Int16 = 0
    result::Float64 = 0
    while counter <= length(discounted_FCFE_Objects)
        result += Discount_FCFE_To_Present_Value(discounted_FCFE_Objects[counter], discount_rate, counter)
        counter += 1
    end
end