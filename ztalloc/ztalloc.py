import sys
import collections

def solve(Range, Lout, Rout):
    seen = set()
    seen.add(Range)
    remaining = collections.deque()
    remaining.append(("", Range))
    while remaining:
        (path, sofar) = remaining.popleft()
        for s in sofar:
            if s < Lout or s > Rout:
                d = False
                break
            d = True
        if d:
            if not(path):
                return "EMPTY"
            else:
                return path
        htuple = (sofar[0]//2, sofar[1]//2)
        if htuple not in seen:
            seen.add(htuple)
            remaining.append((path + 'h', htuple))
        ttuple = ((sofar[0]*3+1, sofar[1]*3+1))
        if (ttuple not in seen) and ttuple[1] < 1000000:
            seen.add(ttuple)
            remaining.append((path + 't', ttuple))
    return "IMPOSSIBLE"

if len(sys.argv) > 1:
    with open(sys.argv[1], "rt") as f:
        Q = int(f.readline())
        for i in range(Q):
            Lin, Rin, Lout, Rout = (map(int, f.readline().split()))
            print(solve((Lin, Rin), Lout, Rout))
