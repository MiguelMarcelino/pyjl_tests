# Temp function:
function array_or_arrays(matrix::Matrix)
    arr::Vector{Vector} = []
    row, col = size(matrix)
    for i = 0:row-1
        curr_pos = i * col
        push!(arr, matrix'[curr_pos+1:curr_pos+col])
    end
    return arr
end
