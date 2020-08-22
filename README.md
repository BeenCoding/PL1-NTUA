# Programming Languages I - NTUA
This course is about learning different types of programming.

This repo has all the exercises given in this course. Problem definitions can be found by clicking the name of the problem (Greek).
* Object Oriented Programming - Java
* Functional Programming - Standard ML
* Scripting Language - Python 3
* Logical Programming - Prolog

# Problems
### _[Powers of 2](https://github.com/BeenCoding/PL1-NTUA/blob/master/exerc20-1.pdf)_ ([C++](https://github.com/BeenCoding/PL1-NTUA/blob/master/powers2/powers2.cpp) | [SWI-Prolog](https://github.com/BeenCoding/PL1-NTUA/blob/master/powers2/powers2.pl) | [Standard ML](https://github.com/BeenCoding/PL1-NTUA/blob/master/powers2/powers2.sml))
* In this problem the inputs are two numbers (N and K). What we are supposed to do is write the number N in exactly K powers of two. We need the lexicographically smallest solution. The output should be written like a list. For example number 42 with exactly 6 powers of 2 has this output --> [2,2,1,0,0,1].
* Restrictions: 1 ≤	K ≤	200.000 and 1 ≤	N ≤	1.000.000.000.
* **SOLUTION:** 
  * We need a parameter (named currK) so as we know how many ones we stored.
  * Convert N into binary, store it in a list and update how many ones are in the representation of the number in binary form. The binary number in the list starts from the LSB (first position of the list is the LSB).
  * While currK is not equal to K we do the following: Iterate from the element at pos 1 of the list and if it is greater or equal than 1 then the element of the previous position is +2. When a change is done the iteration of the lists starts from the begining (pos 1).
  * The last thing needed is to eliminate the 0's in the list so as the output is as expected.
  
### _[Coronagraphs](https://github.com/BeenCoding/PL1-NTUA/blob/master/exerc20-1.pdf)_ ([C++](https://github.com/BeenCoding/PL1-NTUA/blob/master/coronagraph/coronagraph.cpp) | [SWI-Prolog](https://github.com/BeenCoding/PL1-NTUA/blob/master/coronagraph/coronagraph.pl) | [Standard ML](https://github.com/BeenCoding/PL1-NTUA/blob/master/coronagraph/coronagraph.sml))
* In this problem the input is a non directed graph (M is the number of vertices and N is the number of nodes) and we need to determine if it is a coronagraph or not. The graph is defined as coronagraph if it consists of a set of trees, the roots of which are connected in a circle. If it is a coronagraph the output must be 'CORONA' 'number of nodes participating in the cicle' and on the next line the number of nodes of each tree that participates in the cicle in ascending order, else 'NO CORONA'.
* Restrictions: 1 ≤	N,M ≤	1.000.000.
* **SOLUTION:** 
  * After constructing the non directed graph in an adjacency list, first of all we check if the graph is connected. If not then the graph is not coronagraph. 
  * We need a variable named cycles in order to keep how many nodes constitute to the cycle mentioned before. The starting value of this variable is N.
  * We need an array with N positions named length. This will help us to keep how many nodes are participating in the tree.
  * The basic idea of the algorithm is: We need a function (cutEdge) which will basicly finds all the nodes that have only one edge (it cannot be a part of the circle if it has only one edge).We need to iterate through all lists. When finding this edge (u-v) is removed from the adjacency list. So the way to find this edge is by checking which list has size equal to one. When found, the element v is popped from list[u] and we search for the element u in list[v] and remove it as well. After removing u from list[v] we need to check also if list[v].size is equal to one, to repeat the process.
  * When cutting an edge len[remove] += len[u], len[u] = 0 and from cycles (variable) will be deducted 1.
  * When cutEdge function is finished the last thing we need to check if the adjacency list in every position has length that is equal to 2 or 0 (if not then it cannot be a circle because a node is part of a circle only if it has exactly 2 edges). Also an other check that needs to be done is to check cycles (variable) if it is greater or equal to 3. If yes it's a coronagraph else it's not.
  * Print the result.
  
### _[Stay Home](https://github.com/BeenCoding/PL1-NTUA/blob/master/exerc20-2.pdf)_ ([Standard ML](https://github.com/BeenCoding/PL1-NTUA/blob/master/stayhome/stayhome.sml) | [Python](https://github.com/BeenCoding/PL1-NTUA/blob/master/stayhome/stayhome.py) | [Java](https://github.com/BeenCoding/PL1-NTUA/blob/master/stayhome/StayHome.java))
* In this problem the input is a grid NxM, and we need to help Sotiris to reach his home safely. 'S' is the starting position of Sotiris, 'T' is the terminal point (Sotiris' home), 'W' is where the virus starts, 'A' is Airport, 'X' are obstacles and '.' is a blank box. Sotiris moves every 1 second and doesn't want to use any airports to travel through the grid, W (virus) every 2 seconds. If virus reaches 'A' after 5 seconds virus will spread to every Airport in the grid. What is asked is to find the lexicographically smallest path (from starting point 'S' to terminal 'T'). If exists then print the path, else print 'IMPOSSIBLE'.
Both Sotiris and Virus can do the following moves: 'R','L','U','D' which are right,left,up,down respectively.
* Restrictions: 1 ≤	N,M ≤	1000.
* **SOLUTION:**
  * The algorithm used here is a 'modified' bfs. In respect of time, 'S' and 'W' are spread in all **possible** directions to the grid. All 'S' moves are been stored also in an other NxM matrix so as we can find the path if 'S' reached 'T'. 'S' cannot be spread in a box where is a 'W'. When 'T' is reached from 'S' the path is been constructed from the NxM matrix where all 'S' moves are been saved.

### _[Vaccine](https://github.com/BeenCoding/PL1-NTUA/blob/master/exerc20-3.pdf)_ ([SWI-Prolog](https://github.com/BeenCoding/PL1-NTUA/blob/master/vaccine/vaccine.pl) | [Python](https://github.com/BeenCoding/PL1-NTUA/blob/master/vaccine/vaccine.py) | [Java](https://github.com/BeenCoding/PL1-NTUA/tree/master/vaccine/Java))
* In this problem the input is a "word" consisted of 'G','U','A','C' which is the RNA of the virus. We need to find the vaccine. To find the vaccine we must gather all 'A','G','C','U' in an other stack. We are allowed to do three moves: push (which removes the top element of the stack given and places the element to the top of the second stack), complement (which replaces every element in the stack given which its complement element "A-U" and "C-G") and reverse (which inverts the content of the second stack). The answer to the problem is the sequence of the moves we did in order to gather all the letters in the second stack (must be lexicographically smallest solution).
* Restrictions: 1 ≤	N ≤	10, where N is the number of inputs that will follow. The length of the inputs will not exceed 100 and the control cases will be such that a relatively simple BFS solver (like the one we saw in the Java lab) can solve them within the limits of time and memory.
* **SOLUTION:**
  * The algorithm used here is a 'modified' bfs. More for the approach of the bfs can be found in the comments of the code.

# _Timers_
If you want to know the execution time for your program in:
* **SWI Prolog:** 
  * Just call the predicate you want to measure the exec time with the built in predicate time. For example time(my_predicate(A,B)).
  
* **Python 3:** 
  * First we need to import time, so in your imports add: ```import time```.
  * Then we need to get the time, so below import time add ```start = time.time()```.
  * Last thing needed is to get the time again, when all your code is finished, so at the end of the file add ```end = time.time()```.
  * Print the result: ```print("Execution time is: %s seconds " % (end - start))```
  
* **Standard ML:**
  * Use these functions below:
    ```
    fun time_it (action, arg) = 
        let
            val timer = Timer.startCPUTimer ()
            val _ = action arg
            val times = Timer.checkCPUTimer timer
        in
            Time.+ (#usr times, #sys times)
        end
    ```
    ```
    fun r x = print ("Program with input:"^ x ^" takes " ^ Time.toString (time_it ([*****], x)) ^ " seconds.\n");
    ```
    Replace [*****] with the name of the function that you give as input to the inputfile.
  * Call r with the inputfile.
  
* **C++:**
  * After compilation just run the executable file with time.
  ``` 
  time ./executable Inputfile 
  ```
* **Java:**
  * ``` final long startTime = System.currentTimeMillis(); ``` at the top of the code.
  * ``` final long endTime = System.currentTimeMillis(); ``` at the end of the code.
  * ``` System.out.println("Total execution time: " + (endTime - startTime) + "ms"); ``` printing the result.
