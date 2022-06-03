function bisect_right(data::Vector{Int64}, item::Int64)::Int64
    low = 0
    high::Int64 = Int(length(data))
    while low < high
        middle = Int(floor((low + high) / 2))
        if item < data[middle+1]
            high = middle
        else
            low = middle + 1
        end
    end
    return low
end