using Dates

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
    if (month(date) == month(now()) && year(date) == year(now()))
        return 3850412.0
    end
    return 0
end