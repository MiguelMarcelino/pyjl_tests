function bubble_sort(seq::Vector{Int64})::Vector{Int64}
    l = length(seq)
    for _ = 0:l-1
        for n = 1:l-1
            if seq[n+1] < seq[n]
                seq[n], seq[n+1] = (seq[n+1], seq[n])
            end
        end
    end
    return seq
end
