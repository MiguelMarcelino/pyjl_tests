from math import floor
from typing import List

def comb_sort(
        seq: List[int]) -> List[int]:
    gap = len(seq)
    swap = True
    while gap > 1 or swap:
        gap = max(1, floor(gap / 1.25))
        swap = False
        for i in range(len(seq) - gap):
            if seq[i] > seq[i + gap]:
                seq[i], seq[i + gap] = \
                    seq[i + gap], seq[i]
                swap = True
    return seq
