<<<<<<< HEAD


function sieve(n::Int64)
    primes = repeat([true], n)
    primes[1], primes[2] = (false, false)
    for i = 2:Int(sqrt(n) + 1)-1
        if primes[i+1]
            for j = i*i:i:n-1
                primes[j+1] = false
            end
        end
    end
    return [i for i in 0:length(primes)-1 if primes[i+1]]
end

if abspath(PROGRAM_FILE) == @__FILE__
    sieve(parse(Int, sys.argv[2]))
=======

function sieve(n)::Int64
    primes = repeat([true], (n + 1))
    counter = 0
    for i = 2:n-1
        if primes[i+1]
            counter = counter + 1
            for j = i*i:i:n-1
                primes[j+1] = false
            end
        end
    end
    return counter
end

if abspath(PROGRAM_FILE) == @__FILE__
    sieve(parse(Int, append!([PROGRAM_FILE], ARGS)[2]))
>>>>>>> f214ca7f5ced7424e7132e581746e8672e842fb6
end
