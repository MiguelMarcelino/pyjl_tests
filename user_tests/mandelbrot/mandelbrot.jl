function mandelbrot(limit, c)::Int64
    z = 0 + 0im
    for i = 0:limit
        if abs(z) > 2
            return i
        end
        z = z * z + c
    end
    return i + 1
end