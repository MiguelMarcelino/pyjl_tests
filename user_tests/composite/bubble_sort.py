def bubble_sort(seq: List[int]) -> List[int]:
    l = len(seq)
    for _ in range(l):
        for n in range(1, l):
            if seq[n] < seq[n - 1]:
                seq[n - 1], seq[n] = seq[n], seq[n - 1]
    return seq