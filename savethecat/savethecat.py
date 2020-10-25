import sys
import collections

d={}
flood = collections.deque()
cat = collections.deque()

def floodfill(N, M):
    while (flood):
        current = flood.popleft()
        if current[0] - 1 >= 0:
            if d[(current[0] - 1, current[1])][0] !='X' and d[(current[0]-1, current[1])][4] == False:
                d[(current[0] - 1, current[1])] = (d[(current[0] - 1, current[1])][0], '', d[current][2] + 1, d[(current[0] - 1, current[1])][3], True, d[(current[0] - 1, current[1])][5], None)
                flood.append((current[0]-1, current[1]))
        if current[0] + 1 < N:
    	    if d[(current[0] + 1, current[1])][0] !='X' and d[(current[0]+1, current[1])][4] == False:
                d[(current[0] + 1, current[1])] = (d[(current[0] + 1, current[1])][0], '', d[current][2] + 1, d[(current[0] + 1, current[1])][3], True, d[(current[0] + 1, current[1])][5], None)
                flood.append((current[0]+1, current[1]))
        if current[1] - 1 >= 0:
            if d[(current[0], current[1] - 1)][0] !='X' and d[(current[0], current[1] - 1)][4] == False:
                d[(current[0], current[1]-1)] = (d[(current[0], current[1]-1)][0], '', d[current][2] + 1, d[(current[0], current[1]-1)][3], True, d[(current[0], current[1]-1)][5], None)
                flood.append((current[0], current[1]-1))
        if current[1] + 1 < M:
            if d[(current[0], current[1] + 1)][0] !='X' and d[(current[0], current[1] + 1)][4] == False:
                d[(current[0], current[1]+1)] = (d[(current[0], current[1]+1)][0], '', d[current][2] + 1, d[(current[0], current[1]+1)][3], True, d[(current[0], current[1]+1)][5], None)
                flood.append((current[0], current[1]+1))

def catpath(N, M):
    maxtime = 0
    path = ""
    current = cat.popleft()
    maxsquare = current
    if d[maxsquare][2] != -1:
        while True:
            if current[0] + 1 < N:
                if d[(current[0] + 1, current[1])][0] !='X' and d[(current[0]+1, current[1])][5] == False and d[current][3]+1 < d[(current[0]+1, current[1])][2]:
                    d[(current[0]+1, current[1])] = (d[(current[0]+1, current[1])][0], 'D', d[(current[0]+1, current[1])][2], d[current][3]+1, True, True, current)
                    if d[(current[0]+1, current[1])][2] - 1 > maxtime:
                        maxtime = d[(current[0]+1, current[1])][2] - 1
                        maxsquare = (current[0]+1, current[1])
                    elif d[(current[0]+1, current[1])][2] - 1 == maxtime and (current[0]+1, current[1]) < maxsquare:
                        maxsquare = (current[0]+1, current[1])
                    cat.append((current[0]+1, current[1]))
            if current[1] - 1 >= 0:
                if d[(current[0], current[1]-1)][0] !='X' and d[(current[0], current[1]-1)][5] == False and d[current][3]+1 < d[(current[0], current[1]-1)][2]:
                    d[(current[0], current[1]-1)] = (d[(current[0], current[1]-1)][0], 'L', d[(current[0], current[1]-1)][2], d[current][3]+1, True, True, current)
                    if d[(current[0], current[1]-1)][2] - 1 > maxtime:
                        maxtime = d[(current[0], current[1]-1)][2] - 1
                        maxsquare = (current[0], current[1]-1)
                    elif d[(current[0], current[1]-1)][2] - 1 == maxtime and (current[0], current[1]-1) < maxsquare:
                        maxsquare = (current[0], current[1]-1)
                    cat.append((current[0], current[1]-1))
            if current[1] + 1 < M:
                if d[(current[0], current[1]+1)][0] !='X' and d[(current[0], current[1]+1)][5] == False and d[current][3]+1 < d[(current[0], current[1]+1)][2]:
                    d[(current[0], current[1]+1)] = (d[(current[0], current[1]+1)][0], 'R', d[(current[0], current[1]+1)][2], d[current][3]+1, True, True, current)
                    if d[(current[0], current[1]+1)][2] - 1 > maxtime:
                        maxtime = d[(current[0], current[1]+1)][2] - 1
                        maxsquare = (current[0], current[1]+1)
                    elif d[(current[0], current[1]+1)][2] - 1 == maxtime and (current[0], current[1]+1) < maxsquare:
                        maxsquare = (current[0], current[1]+1)
                    cat.append((current[0], current[1]+1))
            if current[0] - 1 >= 0:
                if d[(current[0] - 1, current[1])][0] !='X' and d[(current[0]-1, current[1])][5] == False and d[current][3]+1 < d[(current[0]-1, current[1])][2]:
                    d[(current[0]-1, current[1])] = (d[(current[0]-1, current[1])][0], 'U', d[(current[0]-1, current[1])][2], d[current][3]+1, True, True, current)
                    if d[(current[0]-1, current[1])][2] - 1 > maxtime:
                        maxtime = d[(current[0]-1, current[1])][2] - 1
                        maxsquare = (current[0]-1, current[1])
                    elif d[(current[0]-1, current[1])][2] - 1 == maxtime and (current[0]-1, current[1]) < maxsquare:
                        maxsquare = (current[0]-1, current[1])
                    cat.append((current[0]-1, current[1]))
            if not(cat):
                break
            current = cat.popleft()
        print(maxtime)
        temp = maxsquare
        while d[temp][6] != None:
            path = d[temp][1] + path
            temp = d[temp][6]
        if path == "":
            print("stay")
        else:
            print(path)
    else:
        while True:
            if current[0] + 1 < N:
                if d[(current[0] + 1, current[1])][0] !='X' and d[(current[0]+1, current[1])][5] == False:
                    d[(current[0]+1, current[1])] = (d[(current[0]+1, current[1])][0], 'D', -1, -1, False, True, current)
                    if (current[0]+1, current[1]) < maxsquare:
                        maxsquare = (current[0]+1, current[1])
                    cat.append((current[0]+1, current[1]))
            if current[1] - 1 >= 0:
                if d[(current[0], current[1]-1)][0] !='X' and d[(current[0], current[1]-1)][5] == False:
                    d[(current[0], current[1]-1)] = (d[(current[0], current[1]-1)][0], 'L', -1, -1, False, True, current)
                    if (current[0], current[1]-1) < maxsquare:
                        maxsquare = (current[0], current[1]-1)
                    cat.append((current[0], current[1]-1))
            if current[1] + 1 < M:
                if d[(current[0], current[1]+1)][0] !='X' and d[(current[0], current[1]+1)][5] == False:
                    d[(current[0], current[1]+1)] = (d[(current[0], current[1]+1)][0], 'R', -1, -1, False, True, current)
                    if (current[0], current[1]+1) < maxsquare:
                        maxsquare = (current[0], current[1]+1)
                    cat.append((current[0], current[1]+1))
            if current[0] - 1 >= 0:
                if d[(current[0] - 1, current[1])][0] !='X' and d[(current[0]-1, current[1])][5] == False:
                    d[(current[0]-1, current[1])] = (d[(current[0]-1, current[1])][0], 'U', -1, -1, False, True, current)
                    if (current[0]-1, current[1]) < maxsquare:
                        maxsquare = (current[0]-1, current[1])
                    cat.append((current[0]-1, current[1]))
            if not(cat):
                break
            current = cat.popleft()
        print("infinity")
        temp = maxsquare
        while d[temp][6] != None:
            path = d[temp][1] + path
            temp = d[temp][6]
        if path == "":
            print("stay")
        else:
            print(path)


if len(sys.argv) > 1:
    i = 0
    j = 0
    with open(sys.argv[1], "rt") as f:
        while True:
            l = f.readline()
            if l == "":
                break
            while l[j] != "\n":
                if l[j] == 'W':
                    d[i, j] = (l[j], '', 0, -1, True, False, None)
                    flood.append((i, j))
                elif l[j] == 'A':
                    d[i, j] = (l[j], '', -1, 0, False, True, None)
                    cat.append((i, j))
                else:
                    d[i, j] = (l[j], '', -1, -1, False, False, None)
                j += 1
            M = j
            i += 1
            j = 0
        N = i
floodfill(N, M)
catpath(N, M)
