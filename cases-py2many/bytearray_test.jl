if abspath(PROGRAM_FILE) == @__FILE__
    values = Vector{UInt8}()
    @assert(isa(values, Vector{Int8}) == true)
end
