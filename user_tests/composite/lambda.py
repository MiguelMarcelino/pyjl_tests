def lookup_frequency(results, frame, bits):
    n = 1
    frequency = 0
    for _, n, frequencies in filter(lambda r: r[0] == frame, results):
        frequency += frequencies[bits]
    return frequency, n if n > 0 else 1