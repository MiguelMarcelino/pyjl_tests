from math import factorial


def permutations(n, start, size):
    p = bytearray(range(n))
    count = bytearray(n)

    remainder = start
    for v in range(n - 1, 0, -1):
        count[v], remainder = divmod(remainder, factorial(v))
        for _ in range(count[v]):
            p[:v], p[v] = p[1:v + 1], p[0]