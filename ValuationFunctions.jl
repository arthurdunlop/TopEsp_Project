### Cash Flow to present value
module DiscountCashFlowToPresent
    include("Domain.jl")
    using Dates
    using .DiscountCashFlowToPresentDomain

    export Calculate_UFV_Valuation, Discount_FCFE_To_Present_Value
    
    function Build_FCFE_Collection(generation_Collection::Vector{Float64})
        FCFE_Objects::Vector{FCFE_Object} = []
        date = Dates.now()
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

    function Calculate_UFV_Valuation(generation_Collection::Vector{Float64}, discount_rate::Float64)
        Calculate_Cash_Flow_Present_Value(Build_FCFE_Collection(generation_Collection), discount_rate)
    end

end

### Cash Flow to with entry into investment
module CashFlowWithEntryIntoInvestment 
    include("Domain.jl")
    using Dates
    # using .DiscountCashFlowToPresent
    # using .DiscountCashFlowToPresentDomain
    using .CashFlowWithEntryIntoInvestmentDomain
   
    export Calculate_UFV_Valuation_With_Debt

    function Build_FCFE_Object_With_Entry_Into_Investment_Collection(generation_Collection::Vector{Float64}, entry_Into_Investment::Float64)
        FCFE_Objects_With_Entry_Into_Investment::Vector{FCFE_Object_With_Entry_Into_Investment} = []
        date = Dates.now()
        numero_Periodos_Totais = length(generation_Collection)
        counter::Int64 = 1 
        for geracao in generation_Collection
            push!(
                FCFE_Objects_With_Entry_Into_Investment,
                FCFE_Object_With_Entry_Into_Investment(
                    Index = counter,
                    Data = date,
                    Numero_Periodos_Totais = numero_Periodos_Totais,
                    Geracao = geracao,
                    Entry_Into_Investment = entry_Into_Investment)
                )
            date += Dates.Month(1)
            counter += 1
        end
        return FCFE_Objects_With_Entry_Into_Investment
    end

    function Calculate_Debt_Amount(fees_rates::Dict{Float64, Float64}, debt_value::Float64)
        result::Float64 = 0
        max_index::Float64 = length(keys(fees_rates))
        for (key, value) in fees_rates
            if (debt_value <= key)
                return result += (1 + value) * debt_value
            else
                index = findfirst(==(key), collect(keys(fees_rates)))
                if (index == max_index)
                    result += (1 + value) * debt_value
                else
                    result += (1 + value) * key
                    debt_value -= key
                end
            end
        end
        return result
    end

    function Aggregate_FCFE_To_Future_Value_For_Next_Period(value::Float64, discount_rate::Float64)
        return value * (1 + discount_rate)
    end
    
    function Calculate_Cash_Flow_Future_Value(
        FCFE_Object_With_Entry_Into_Investment::Vector{FCFE_Object_With_Entry_Into_Investment},
        discount_rate::Float64, 
        fees_rates::Dict{Float64, Float64}
        )
        counter::Int16 = 1
        caixa_Agregado::Float64 = 0
        debt_amount::Float64 = 0
        capex_in_debt::Float64 = Calculate_Debt_Amount(fees_rates, FCFE_Object_With_Entry_Into_Investment[counter].CAPEX_IN_DEBT)
        private_capex::Float64 = FCFE_Object_With_Entry_Into_Investment[counter].CAPEX_CAPITAL_PROPRIO
        while counter <= length(FCFE_Object_With_Entry_Into_Investment)
            future_value = Aggregate_FCFE_To_Future_Value_For_Next_Period(caixa_Agregado, discount_rate)
            fluxo_de_caixa = FCFE_Object_With_Entry_Into_Investment[counter].FCFE
            debt_amount = Calculate_Debt_Amount(fees_rates, debt_amount)
            caixa_Agregado = future_value + fluxo_de_caixa - debt_amount - capex_in_debt
            if (caixa_Agregado <= 0)
                debt_amount = caixa_Agregado
                caixa_Agregado = 0
            else
                debt_amount = 0
            end
            counter += 1
        end
            private_capex_future_value = private_capex * ((1 + discount_rate)^length(FCFE_Object_With_Entry_Into_Investment))
            return caixa_Agregado + debt_amount - private_capex_future_value
    end

    function Calculate_UFV_Valuation_With_Debt(
        generation_Collection::Vector{Float64}, 
        discount_rate::Float64, 
        fees_rates::Dict{Float64, Float64}, 
        entry_Into_Investment::Float64
        )
        return Calculate_Cash_Flow_Future_Value(
                    Build_FCFE_Object_With_Entry_Into_Investment_Collection(
                        generation_Collection, 
                        entry_Into_Investment
                    ), discount_rate, 
                    fees_rates
                    )
    end

    function Discount_FCFE_To_Present_Value(value_to_discount::Float64, discount_rate::Float64, time_period::Int64) 
        return value_to_discount / (1 + discount_rate) ^ time_period
    end

end



