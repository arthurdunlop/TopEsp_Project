#Imports packages
include("Domain.jl")
include("ValuationFunctions.jl")
include("GenerationFunctions.jl")
include("RiskFunctions.jl")
using Plots
using StatsPlots


#Premissas
#Geração mensal prevista pelo software PVSyst.
g = ([188.68	149.67	168.61	155.70	130.07	121.24	143.55	148.77	149.85	161.02	152.64	177.24	188.61	149.55	168.41	155.45	129.81	120.95	143.15	148.29	149.31	160.37	151.97	176.40	187.70	148.83	167.61	154.71	129.19	120.37	142.46	147.58	148.59	159.61	151.24	175.55	186.80	148.12	166.80	153.97	128.57	119.80	141.78	146.88	147.88	158.84	150.52	174.71	185.91	147.41	166.00	153.23	127.96	119.22	141.10	146.17	147.17	158.08	149.80	173.87	185.02	146.70	165.21	152.50	127.34	118.65	140.42	145.47	146.47	157.33	149.08	173.04	184.13	146.00	164.42	151.77	126.73	118.08	139.75	144.78	145.77	156.57	148.37	172.21	183.25	145.30	163.63	151.04	126.13	117.52	139.08	144.08	145.07	155.82	147.66	171.39	182.38	144.61	162.85	150.32	125.52	116.96	138.42	143.39	144.38	155.08	146.95	170.57	181.50	143.91	162.07	149.60	124.92	116.40	137.75	142.71	143.68	154.33	146.25	169.75	180.63	143.23	161.29	148.88	124.32	115.84	137.09	142.02	143.00	153.60	145.55	168.94	179.77	142.54	160.52	148.17	123.73	115.28	136.44	141.34	142.31	152.86	144.85	168.13	178.91	141.86	159.75	147.46	123.14	114.73	135.79	140.67	141.63	152.13	144.16	167.33	178.05	141.18	158.99	146.75	122.55	114.18	135.14	139.99	140.95	151.40	143.47	166.52	177.20	140.50	158.23	146.05	121.96	113.64	134.49	139.32	140.28	150.67	142.78	165.73	176.35	139.83	157.47	145.35	121.38	113.09	133.84	138.66	139.61	149.95	142.10	164.93	175.51	139.16	156.71	144.65	120.80	112.55	133.20	137.99	138.94	149.24	141.41	164.14	174.67	138.49	155.96	143.96	120.22	112.01	132.57	137.33	138.27	148.52	140.74	163.36	173.83	137.83	155.22	143.27	119.64	111.48	131.93	136.67	137.61	147.81	140.06	162.58	173.00	137.17	154.47	142.59	119.07	110.94	131.30	136.02	136.95	147.10	139.39	161.80	172.17	136.51	153.74	141.90	118.50	110.41	130.67	135.37	136.30	146.40	138.73	161.02	171.35	135.86	153.00	141.22	117.93	109.88	130.05	134.72	135.64	145.70	138.06	160.25	170.53	135.21	152.27	140.55	117.37	109.36	129.42	134.08	134.99	145.00	137.40	159.48	169.71	134.56	151.54	139.88	116.81	108.83	128.80	133.43	134.35	144.31	136.74	158.72	168.90	133.92	150.81	139.21	116.25	108.31	128.19	132.80	133.70	143.61	136.09	157.96	])[:]
#Custo de capital calculado a partir do modelo descrito TCC
mensal_capital_rate = 0.006586444637
#Taxa de juros
function Convert_Rates_From_aa_To_am(value_aa::Float64)
    return ( 1 + value_aa) ^ (1/12) - 1
end
fee_rates::Dict{Float64, Float64} = Dict(
    1000000 => Convert_Rates_From_aa_To_am(0.05),
    2000000 => Convert_Rates_From_aa_To_am(0.08),
    3000000 => Convert_Rates_From_aa_To_am(0.12)
    )
#Atribui valor para a taxa de variação da distrubuição uniforme
variation_Rate = 0.1
# Constroi vetor [0,100] com 100 intervalos equidistantes representando as entradas do investidor no projeto
entriesIntoInvestment = range(0, stop=1, length=100)

###
### G2
###

#Future Value With Debt WorkFlow

#Calcula o VPL utilizando acrescentando os parametros de divida
valuationsForEntries::Vector{Float64} = []
ufv_valuation_With_Debt = Calculate_UFV_Valuation_With_Debt(g, mensal_capital_rate, fee_rates, 1.)
result_present_100::Float64 = ufv_valuation_With_Debt / ((1 + mensal_capital_rate) ^ length(g))
push!(valuationsForEntries, result_present_100)
ufv_valuation_With_Debt = Calculate_UFV_Valuation_With_Debt(g, mensal_capital_rate, fee_rates, 0.85)
result_present_75::Float64 = ufv_valuation_With_Debt / ((1 + mensal_capital_rate) ^ length(g))
push!(valuationsForEntries, result_present_75)
ufv_valuation_With_Debt = Calculate_UFV_Valuation_With_Debt(g, mensal_capital_rate, fee_rates, 0.5)
result_present_50::Float64 = ufv_valuation_With_Debt / ((1 + mensal_capital_rate) ^ length(g))
push!(valuationsForEntries, result_present_50)
ufv_valuation_With_Debt = Calculate_UFV_Valuation_With_Debt(g, mensal_capital_rate, fee_rates, 0.25)
result_present_25::Float64 = ufv_valuation_With_Debt / ((1 + mensal_capital_rate) ^ length(g))
push!(valuationsForEntries, result_present_25)
ufv_valuation_With_Debt = Calculate_UFV_Valuation_With_Debt(g, mensal_capital_rate, fee_rates, 0.)
result_present_0::Float64 = ufv_valuation_With_Debt / ((1 + mensal_capital_rate) ^ length(g))
push!(valuationsForEntries, result_present_0)
plot(valuationsForEntries, xlabel="% Entrada no Investimento", ylabel="VPL", title="Boxplot dos Valores na Matriz", label = false)

counter_ = 0
matriz = zeros(Float64, 100, 100)

while counter_ < 100
    v = GenerateNormalGeneration(g, 40.)
    normal_generation = map(x -> x < 0 ? 0.0 : x, v)
    valuationsForEntries::Vector{Float64} = []
    for entryIntoInvestment in entriesIntoInvestment
        futureResult::Float64 = Float64(Calculate_UFV_Valuation_With_Debt(normal_generation, mensal_capital_rate, fee_rates, entryIntoInvestment))
        presentResult::Float64 = futureResult / ((1 + mensal_capital_rate) ^ length(g))
        push!(valuationsForEntries, presentResult)
    end
    global counter_ += 1
    matriz[counter_, :] = valuationsForEntries
end

boxplot(matriz, xlabel="% Entrada no Investimento", ylabel="VPL", title="Boxplot dos Valores na Matriz", label = false)

#Get the mean for the 5% lowest values from each column of given matrix for risk matric
mean_of_lowest_values = Mean_of_lowest_values_from_Columns(matriz)
plot(mean_of_lowest_values, label="CVar", xlabel="Coluna", ylabel="Valor Médio", title="Médias por Coluna")

# Gráfico de linhas das médias por coluna
mean_values = mean(matriz, dims=1)[:]  # médias por coluna
plot!(mean_values, label="Média", xlabel="Coluna", ylabel="Valor Médio", title="Médias por Coluna")

# Gráfico de retorno pelo risco
plot((mean_values, mean_of_lowest_values), xlabel="Retorno", ylabel="Risco", title="Retorno X Risco")


###
### G1
###

#Discounted Work Flow
###
#Calculo do VPL com as informações de geração do PVSyst e custo de capital do modelo TCC
ufv_valuation_result = Calculate_UFV_Valuation(g, mensal_capital_rate)

#1000 Simulações de VPL
counter = 0
vpl_Vector = []
while counter < 1000
    uniform_Generation = GenerateUniformGeneration(g, variation_Rate)
    ufv_valuation_result_Uniform_Generation = Calculate_UFV_Valuation(uniform_Generation, mensal_capital_rate)
    push!(vpl_Vector, ufv_valuation_result_Uniform_Generation)
    global counter +=  1
end

# Compute the outer product of the two vectors
simulated_vpls_for_privet_capital_rate = vpl_Vector * transpose(entriesIntoInvestment)

#Get the mean for the 5% lowest values from each column of given matrix for risk matric
mean_of_lowest_values = Mean_of_lowest_values(simulated_vpls_for_privet_capital_rate)

#Metrics
# Boxplot dos valores na matriz
boxplot(simulated_vpls_for_privet_capital_rate, xlabel="% Entrada no Investimento", ylabel="VPL", title="Boxplot dos Valores na Matriz", label = false)

# Gráfico de linhas das médias por coluna
mean_values = mean(simulated_vpls_for_privet_capital_rate, dims=1)[:]  # médias por coluna
plot(mean_values, xlabel="Coluna", ylabel="Valor Médio", title="Médias por Coluna")
