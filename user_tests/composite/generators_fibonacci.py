def fibonacci():
    current, nxt = 0, 1
    while True:
        current, nxt = nxt, nxt + current
        yield current
