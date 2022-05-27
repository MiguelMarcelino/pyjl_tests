

function sieve(n)
    primes = ones(Float64, n)
    primes[1], primes[2] = (false, false)
    for i = 2:Int(√(n) + 1)-1
        if primes[i+1]
            primes[end:i:i*i+1] = false
        end
    end
    return [i for i in primes if primes[i] != 0]
end

if abspath(PROGRAM_FILE) == @__FILE__
    sieve(parse(Int, sys.argv[2]))
end
