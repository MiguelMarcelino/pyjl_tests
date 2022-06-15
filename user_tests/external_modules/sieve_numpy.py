import numpy as np


def sieve(n):
    primes = np.ones(n, dtype=bool)
    primes[0], primes[1] = False, False
    for i in range(2, int(np.sqrt(n) + 1)):
        if primes[i]:
            # Vectorization of the assignment operation (Uses a loop in C)
            primes[i*i::i] = False 
    return np.flatnonzero(primes)