function binomial_coef(n::Int64, k::Int64)
    C = [[0 for x = 0:k] for x = 0:n]
    for i = 0:n
        for j = 0:min(i, k)
            if j == 0 || j == i
                C[i+1][j+1] = 1
            else
                C[i+1][j+1] = C[i][j] + C[i][j+1]
            end
        end
    end
    return C[n+1][k+1]
end

if abspath(PROGRAM_FILE) == @__FILE__
    @assert(binomial_coef(10, 6) == 210)
    @assert(binomial_coef(20, 6) == 38760)
    @assert(binomial_coef(4000, 6) == 5667585757783866000)
end
