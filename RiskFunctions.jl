function Mean_of_lowest_values(matrix::Matrix{T}) where T<:Real
    num_rows, num_cols = size(matrix)
    num_values_to_select = round(Int, 0.05 * num_rows)
    means = similar(matrix, Float64, num_cols)

    for j in 1:num_cols
        sorted_col = sort(matrix[:, j])
        lowest_values = sorted_col[1:num_values_to_select]
        means[j] = mean(lowest_values)
    end

    return means
end

function Mean_of_lowest_values_from_Columns(matrix::Matrix{T}) where T<:Real
    num_rows, num_cols = size(matrix)
    num_values_to_select = round(Int, 0.05 * num_rows)
    means = []
    for j in 1:num_cols
        sorted_col = sort(matrix[:, j])
        lowest_values = sorted_col[1:num_values_to_select]
        push!(means, mean(lowest_values))
    end
    return means
end