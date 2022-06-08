import heapq

class PriorityQueue:
    def __init__(self):
        self._q = []

    def add(self, value, priority=0):
        heapq.heappush(self._q, (priority, value))

    def pop(self):
        return heapq.heappop(self._q)[-1]
