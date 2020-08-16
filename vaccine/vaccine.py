from collections import deque

#----------------READ INPUT FILE----------------#
inputfile = open("vaccine.in1")
getInput = inputfile.read().split('\n')[:-1]
#----------------END READ INPUT-----------------#

#function to make the complements as the exercise says: A <--> U and G <--> C
def complement(cLet):
    if(cLet=='A'): return('U')
    if(cLet=='U'): return('A')
    if(cLet=='G'): return('C')
    if(cLet=='C'): return('G')

#function that makes the move. Gets right stack and the current letter.
#if the right stack is empty just return the current letter.
#else if the highest in stack is equal to the current letter that is going to be in stack return only the stack
#else return the addition of current letter top of the stack
def p(right, curLetter):
    if(not right): 
        return curLetter
    elif(right[0] == curLetter): 
        return(right)
    else: 
        return(curLetter + right)

#function to validate the move that was made with p function. In this algorithm we keep only to the right stack
#only the 4 letters(A,C,G,U). no dublicates. So the length cannot be greater than 4 or right be empty.
#if the first check is passed then we need to check the first letter(top of stack) with all the others so as it 
#is different. If equal then false. We do the same thing(same check) but starting from the end of the string and
#checking it with all the others if different. If not then false. The reason we do this is because valid function
#checks all moves(either is reversed or not).
def valid(right):
    if(len(right)>4) or (not right): return False
    for i in range(1, len(right)):
        if(right[0] == right[i]):
            return False
    for i in range(len(right)-1):
        if(right[len(right)-1] == right[i]):
            return False
    return True

# "main code"
for k in range(int(getInput[0])):
    left = getInput[k+1]                                            # left every time is the string we check to find the path.
    childrenCounter = 1                                             # always set to 1 so as the first time for stmt will run
    s = deque()                                                     # declaring every time s deque where all the possible paths are stored
    s.append((0,"",""))                                             # initial state(s keeps (leftFlag,right,path))
    while(left):                                                    # while there are letters do
        SavedcurLetter = left[len(left)-1]                          # current letter every time by cutting the rightmost character of string
        left = left[:-1]                                            # cutting the letter from string
        
        curChCounter = childrenCounter                              # saving the childrens number so as we do the for curChCounter times
        childrenCounter = 0                                         # setting childrenCounter to zero, so as we count how many children will be born in this iteration
        
        # the moves will be done with this order: cp,crp,p,rp so as we find the lexicographically smallest solution
        # also when a move is done children's counter is increased by one, so as we now how many times for statement will run.

        for j in range(curChCounter):
            (leftFlag, right, path) = s.popleft()                   # pop the leftmost element from the deque
            if(leftFlag == 1):                                      # leftFlag let us know wether this element needs to be complement or not
                curLetter = complement(SavedcurLetter)
            else:
                curLetter = SavedcurLetter
            if(right):                                              # if right isnt empty then we can do this, else there is no reason to do
                newRight = p(right, complement(curLetter))          # its an optimisation because they can never start from cp
                if(valid(newRight)):
                    s.append((1-leftFlag, newRight, path+"cp"))
                    childrenCounter += 1

            if(len(right) > 1):                                     # if length of right is greater than 1 we can proceed to crp move
                newRight = p(right[::-1], complement(curLetter))    # else there is no reason cause reverse gives same result
                if(valid(newRight)):
                    s.append((1-leftFlag, newRight, path+"crp"))
                    childrenCounter += 1

            newRight = p(right, curLetter)                          # always to the p move
            if(valid(newRight)):
                s.append((leftFlag, newRight, path+"p"))
                childrenCounter += 1

            if(len(right) > 1):                                     # if length of right is greater than 1 we can proceed to rp move
                newRight = p(right[::-1], curLetter)                # else there is no reason cause reverse gives same result
                if(valid(newRight)):
                    s.append((leftFlag, newRight, path+"rp"))
                    childrenCounter += 1

    #finding the best path. Setting the best path to be the s[0][2] --> [2] is the 3rd thing saved in that triplet
    bestpath = s[0][2]

    #iterating through all s and checking wether the current bestpath has more length than the s[i][2] or 
    #if they have same length BUT s[i][2] is smaller(lexicographically less) than bestpath.
    for i in range(len(s)):
        if(len(s[i][2]) < len(bestpath) or (len(s[i][2]) == len(bestpath)) and s[i][2] < bestpath):
            bestpath = s[i][2]
    print(bestpath)
