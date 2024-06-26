## Cash Flow With Entry Into Investment Object
module CashFlowWithEntryIntoInvestmentDomain
    using Dates
    
    #Object for projecting Cash Flows with entry into investment
    Base.@kwdef struct FCFE_Object_With_Entry_Into_Investment
        Index::Int64
        Data::DateTime
        Numero_Periodos_Totais::Int16
        Entry_Into_Investment::Float64

        #Properties for FCFE workflow
        Geracao::Float64
        Tarifa_Liquida::Float64 = Calculate_Liquid_Tax(Index)
        Receita_Bruta::Float64 = Tarifa_Liquida * Geracao
        Impostos_Diretos::Float64 = (0.0365 * Receita_Bruta) + 9670.0
        Receita_Liquida::Float64 = Receita_Bruta - Impostos_Diretos
        OPEX::Float64 = 13955.85
        EBITDA::Float64 = Receita_Liquida - OPEX
        Depreciacao::Float64 = 2815000.0 / Numero_Periodos_Totais
        EBT::Float64 = EBITDA - Depreciacao
        Imposto_Renda::Float64 = Receita_Bruta * 0.34 * 0.32
        CAPEX::Float64 = Calculate_CAPEX_With_Entry_Into_Investment(Data)
        CAPEX_IN_DEBT::Float64 = Calculate_Inicial_Debt(CAPEX, Entry_Into_Investment)
        CAPEX_CAPITAL_PROPRIO = CAPEX - CAPEX_IN_DEBT
        FCFE::Float64 = EBT - Imposto_Renda + Depreciacao
    end

    function Calculate_CAPEX_With_Entry_Into_Investment(date::DateTime)
        if (month(date) == month(now()) && year(date) == year(now()))
            return Float64(3850412.0)
        end
        return Float64(0)
    end

    function Calculate_Inicial_Debt(capex::Float64, entry_Into_Investment::Float64)
        return (Float64(1) - entry_Into_Investment) * capex
    end

    function Calculate_Liquid_Tax(Index::Int64)
        liquid_Tax_Collection = ([671.88	667.84	668.36	668.75	660.53	652.88	664.72	670.43	658.24	666.66	659.42	660.16	644.67	640.60	641.09	641.45	633.18	625.48	637.32	643.01	630.74	639.16	631.86	632.57	617.13	613.04	613.53	613.89	605.59	597.85	609.74	615.46	603.13	611.59	604.25	604.97	589.59	585.48	585.98	586.34	577.99	570.22	582.16	587.91	575.52	584.02	576.65	556.89	541.57	537.44	537.93	538.29	529.91	522.10	534.10	539.88	527.43	535.97	528.56	508.80	520.71	516.56	517.06	517.42	509.00	501.15	513.21	519.02	506.51	515.09	507.64	487.89	499.85	495.68	496.19	496.55	488.08	480.20	492.32	498.15	485.58	494.21	486.73	466.97	460.88	456.69	457.19	457.56	449.05	441.13	453.31	459.17	446.54	455.21	447.69	427.94	440.02	435.81	436.32	436.68	428.14	420.17	432.41	438.30	425.61	434.32	426.76	427.50	439.64	435.41	435.92	436.29	427.70	419.70	432.00	437.91	425.16	433.91	426.32	427.06	439.26	435.01	435.52	435.89	427.26	419.22	431.58	437.52	424.71	433.50	425.88	426.62	438.88	434.61	435.12	435.49	426.82	418.74	431.16	437.13	424.26	433.09	425.43	426.18	438.49	434.20	434.72	435.09	426.38	418.26	437.32	443.33	430.39	439.26	431.56	432.32	444.69	440.38	440.90	441.27	432.52	424.36	436.90	442.93	429.93	438.85	431.11	431.87	444.30	439.97	440.49	440.87	432.07	423.88	436.47	442.53	429.47	438.43	430.66	431.42	443.91	439.56	440.08	440.46	431.62	423.39	436.04	442.13	429.01	438.01	430.20	430.97	443.52	439.14	439.67	440.05	431.17	422.90	435.61	441.73	428.54	437.59	429.74	430.51	443.12	438.73	439.26	439.64	430.72	422.40	435.18	441.33	428.08	437.17	429.28	430.05	442.73	438.31	438.84	439.23	430.26	421.91	434.74	440.92	427.61	436.74	428.82	429.59	442.33	437.89	438.42	438.81	429.80	421.41	434.31	440.52	427.14	436.32	428.36	429.13	441.93	437.47	438.01	438.40	429.34	420.91	433.87	440.11	426.66	435.89	427.89	401.62	401.14	400.65	400.17	399.69	399.20	398.72	398.23	397.75	397.27	396.78	396.30	395.81	395.33	394.85	394.36	393.88	393.39	392.91	392.43	391.94	391.46	390.97	390.49	390.01	389.52	389.04	388.55	388.07	387.59	387.10	386.62	386.13	385.65	385.17	384.68	384.20	383.71	383.23	382.75	382.26	381.78	381.29	380.81	380.33	379.84	379.36	378.87	378.39])[:]
        return liquid_Tax_Collection[Index]
    end

    export FCFE_Object_With_Entry_Into_Investment
end

#Discount Cash Flow To Present Object
module DiscountCashFlowToPresentDomain
    using Dates

    #Object for discount Cash Flows to present
    Base.@kwdef struct FCFE_Object
        Index::Int64
        Data::DateTime
        Numero_Periodos_Totais::Int16

        #Properties for FCFE workflow
        Geracao::Float64
        Tarifa_Liquida::Float64 = Calculate_Liquid_Tax(Index)
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

    function Calculate_Liquid_Tax(Index::Int64)
        liquid_Tax_Collection = ([671.88	667.84	668.36	668.75	660.53	652.88	664.72	670.43	658.24	666.66	659.42	660.16	644.67	640.60	641.09	641.45	633.18	625.48	637.32	643.01	630.74	639.16	631.86	632.57	617.13	613.04	613.53	613.89	605.59	597.85	609.74	615.46	603.13	611.59	604.25	604.97	589.59	585.48	585.98	586.34	577.99	570.22	582.16	587.91	575.52	584.02	576.65	556.89	541.57	537.44	537.93	538.29	529.91	522.10	534.10	539.88	527.43	535.97	528.56	508.80	520.71	516.56	517.06	517.42	509.00	501.15	513.21	519.02	506.51	515.09	507.64	487.89	499.85	495.68	496.19	496.55	488.08	480.20	492.32	498.15	485.58	494.21	486.73	466.97	460.88	456.69	457.19	457.56	449.05	441.13	453.31	459.17	446.54	455.21	447.69	427.94	440.02	435.81	436.32	436.68	428.14	420.17	432.41	438.30	425.61	434.32	426.76	427.50	439.64	435.41	435.92	436.29	427.70	419.70	432.00	437.91	425.16	433.91	426.32	427.06	439.26	435.01	435.52	435.89	427.26	419.22	431.58	437.52	424.71	433.50	425.88	426.62	438.88	434.61	435.12	435.49	426.82	418.74	431.16	437.13	424.26	433.09	425.43	426.18	438.49	434.20	434.72	435.09	426.38	418.26	437.32	443.33	430.39	439.26	431.56	432.32	444.69	440.38	440.90	441.27	432.52	424.36	436.90	442.93	429.93	438.85	431.11	431.87	444.30	439.97	440.49	440.87	432.07	423.88	436.47	442.53	429.47	438.43	430.66	431.42	443.91	439.56	440.08	440.46	431.62	423.39	436.04	442.13	429.01	438.01	430.20	430.97	443.52	439.14	439.67	440.05	431.17	422.90	435.61	441.73	428.54	437.59	429.74	430.51	443.12	438.73	439.26	439.64	430.72	422.40	435.18	441.33	428.08	437.17	429.28	430.05	442.73	438.31	438.84	439.23	430.26	421.91	434.74	440.92	427.61	436.74	428.82	429.59	442.33	437.89	438.42	438.81	429.80	421.41	434.31	440.52	427.14	436.32	428.36	429.13	441.93	437.47	438.01	438.40	429.34	420.91	433.87	440.11	426.66	435.89	427.89	401.62	401.14	400.65	400.17	399.69	399.20	398.72	398.23	397.75	397.27	396.78	396.30	395.81	395.33	394.85	394.36	393.88	393.39	392.91	392.43	391.94	391.46	390.97	390.49	390.01	389.52	389.04	388.55	388.07	387.59	387.10	386.62	386.13	385.65	385.17	384.68	384.20	383.71	383.23	382.75	382.26	381.78	381.29	380.81	380.33	379.84	379.36	378.87	378.39])[:]
        return liquid_Tax_Collection[Index]
    end

    export FCFE_Object
end
