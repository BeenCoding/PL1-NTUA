from collections import deque
import sys

#----------------READ INPUT FILE----------------#
inputfile = open("stayhome.in17")
getInput = inputfile.read().split('\n')[:-1]
#----------------END READ INPUT-----------------#

#-------------------INIT N,M,TABLES--------------------#
N = len(getInput)
M = len(getInput[0])
t = 0
reached = False
activated = 0
airports_deque = deque()
s_deque = deque()
virus_deque = deque()
globe = [[0 for j in range(M)] for i in range(N)]
previous = [[0 for j in range(M)] for i in range(N)]

#----------------------END INIT------------------------#

def validMove(x,y,idx,move):
    if ((x < 0) or (x >= N) or (y < 0) or (y >= M)):
        return
    if(globe[x][y] == 'X'):
        return

    if(idx == 'S' or idx == 'Z'):
        if(globe[x][y] == 'T'):
            if(previous[x][y]==0):
                previous[x][y] = move
            else:
                if(move > previous[x][y]):
                    previous[x][y]=move
            global reached
            reached = True
        elif(globe[x][y] == '.'):
            globe[x][y] = 'S'
            previous[x][y] = move
            s_deque.append((x,y))
        elif(globe[x][y] == 'A'):
            globe[x][y] = 'Z'
            previous[x][y] = move
            s_deque.append((x,y)) 
        return   
    
    if(idx == 'W'):
        if(globe[x][y] == 'T'):
            print('IMPOSSIBLE\n')
            sys.exit()
            return
        elif(globe[x][y] == 'S' or globe[x][y] == '.'):
            globe[x][y] = 'W'
            virus_deque.append((x,y))
            return
        elif(globe[x][y] == 'Z' or globe[x][y] == 'A'):
            globe[x][y] = 'W'
            airports_deque.remove((x,y))
            virus_deque.append((x,y))
            global activated
            activated = 1
            return

    if(idx == 'I'):
        if(globe[x][y] == 'T'):
            print('IMPOSSIBLE\n')
            sys.exit()
        elif(globe[x][y] == 'S' or globe[x][y] == '.'):
            globe[x][y]='I'
            airports_deque.append((x,y))
        return

def spread(x,y):
    validMove(x+1,y,globe[x][y],'D')
    validMove(x,y-1,globe[x][y],'L')
    validMove(x,y+1,globe[x][y],'R')
    validMove(x-1,y,globe[x][y],'U')

for i in range(N):
    for j in range(M):
        if(getInput[i][j] == 'A'):
            airports_deque.append((i,j))
        if(getInput[i][j] == 'S'):
            s_deque.append((i,j))
            startingPx,startingPy=(i,j)
        if(getInput[i][j] == 'W'):
            virus_deque.append((i,j))
        if(getInput[i][j] == 'T'):
            finishingPx,finishingPy=(i,j)
        globe[i][j] = getInput[i][j]

while(not reached):
    if(t % 2 == 1):
        length_virus = len(virus_deque)
        for k in range (length_virus):
            x,y = virus_deque.popleft()
            spread(x,y)

    if((activated >= 6) and (activated % 2 == 0) and (t % 2 == 0)):
        length_airport = len(airports_deque)
        for k in range (length_airport):
            x,y = airports_deque.popleft()
            if(globe[x][y]=='A' or globe[x][y]=='Z' or globe[x][y]=='S'):
                globe[x][y]='I'
                airports_deque.append((x,y))
            else:
                spread(x,y)

    for counter in range (len(s_deque)):
        x,y = s_deque.popleft()
        if(globe[x][y] != 'S' and globe[x][y] != 'Z'):
            temp = globe[x][y]
            globe[x][y] = 'S'
            spread(x,y)
            globe[x][y] = temp
        else:
            spread(x,y)
    
    if(activated > 0):
        activated += 1
    t += 1


path = previous[finishingPx][finishingPy]

while(finishingPx != startingPx or finishingPy != startingPy ):
    path = previous[finishingPx][finishingPy] + path
    if(previous[finishingPx][finishingPy] == 'U'):
        finishingPx += 1
    elif(previous[finishingPx][finishingPy] == 'D'):
        finishingPx -= 1
    elif(previous[finishingPx][finishingPy] == 'L'):
        finishingPy += 1
    elif(previous[finishingPx][finishingPy] == 'R'):
        finishingPy -= 1

    
path = path[:-1]
print(t)
print(path,"\n")

