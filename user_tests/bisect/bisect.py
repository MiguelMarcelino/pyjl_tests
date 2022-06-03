def bisect_right(data: List[int], item: int) -> int:
    low = 0
    high: int = int(len(data))
    while low < high:
        middle = int((low + high) / 2)
        if item < data[middle]:
            high = middle
        else:
            low = middle + 1
    return low