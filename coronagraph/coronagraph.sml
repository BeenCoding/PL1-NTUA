local
    (*deletes the element which is in elem_pos of the sublist that is passed as arg*)
    fun delete [] _ _ _ = []
      | delete (x::xs) elem_pos cur_pos acc =
      if (cur_pos = elem_pos) then (xs@acc)
      else delete xs elem_pos (cur_pos + 1) ([x]@acc)

    (*calls remove function, and gets back the updated sublist. Then
    swaps the old sublist  which is at (pos) with the updated sublist *)
    fun erase adjList pos elem_pos = 
    let 
      val sublist = Array.sub(adjList,pos)
      val delete_elem = delete sublist elem_pos 0 []
    in
      Array.update(adjList,pos,delete_elem) ; adjList
    end

    (*finds first element of the sublist that is in pos of adjList*)
    fun first_element adjList pos = List.nth(Array.sub(adjList,pos),0);

    (*finds the position of a specific element(value) in that sublist*)
    fun find_elem_pos [] pos value = ~1
      | find_elem_pos sublist pos value = if List.nth(sublist,pos) = value then (pos) else (find_elem_pos sublist (pos+1) value);

    (*Adding edge u-v, by adding vertex u in adjList[v] and vertex v in adjList[u]*)
    fun addEdge u v adjList = 
        let
            val sublist =  Array.sub(adjList,u)
            val updsublist = [v] @ sublist
        in
            Array.update(adjList,u,updsublist); adjList
        end

    (*(a)Finding all nodes that have only one edge.Removing the edge u-v.Way to find this edge is by searching
    which list has size equal to one. When found, pop element v from list[u] and search in list[v] for element
    u and remove it. Also after removing u from list[v] check list[v] size if it is equal to one, to repeat process.
    (b)This function also updates the length list where are the weights of the nodes. 
    (c)Also returns how many nodes are involved in a cycle.*)

    (*val x is the element to be removed, the only element of a sublist.
  val xList is a sublist of adjList in x position.
  val y is the position of sublist_index value in xList
  val upd_adjList: erases from sublist at position sublist_index the only element thats inside
                   erases from sublist x the element at y position.
  val upd_weight: adds the weight of node x and node sublist_index.
  val upd_len_list: updates lengthlist at position x with value upd_weight
                    updates lengthlist at position sublist_index with 0 as it no longer exists.*)
    fun cutEdge_Aux (adjList,lengthlist,cycles) sublist_index =
        if List.length(Array.sub(adjList,sublist_index)) = 1 then 
            let
                val x = first_element adjList sublist_index
                val xList = Array.sub(adjList,x)
                val y = find_elem_pos xList 0 sublist_index
                val upd_adjList = erase (erase adjList sublist_index 0) x y
                val upd_weight = (Array.sub(lengthlist,x) + Array.sub(lengthlist,sublist_index))
                val upd_len_list = Array.update((Array.update(lengthlist,x,upd_weight);lengthlist),sublist_index,0)
            in
                cutEdge_Aux (upd_adjList,(upd_len_list;lengthlist),(cycles - 1)) x
            end
        else (adjList,lengthlist,cycles)

    (*calls cutEdge_Aux until no vertices left to check, and then returns the tuple(adjList,lengthlist,cycles)*)
    fun cutEdge (adjList,lengthlist,cycles) sublist_index 0 = (adjList,lengthlist,cycles)
      | cutEdge (adjList,lengthlist,cycles) sublist_index vertices = 
        cutEdge (cutEdge_Aux (adjList,lengthlist,cycles) sublist_index) (sublist_index+1) (vertices-1)

    (*creates an empty list of n elements with value.*)
    fun empty_list_of n value = Array.array(n,value)

    (*next two functions are for filling up the adjList with the input.*)
    fun addInputAux [] adjList = adjList
      | addInputAux (u::v::rest) adjList = addInputAux rest (addEdge v u (addEdge u v adjList))

    fun addInput inputList n = addInputAux inputList (empty_list_of (n+1) [])

    (*Checks if its corona or not by checking the length of each sublist in adjList. Must be 0 or 2 to be corona.*)
    fun corona 1 i adjList = true
      | corona length i adjList = 
        let
            val ith_list = Array.sub(adjList,i)
            val length_ith_list = List.length(ith_list)
        in
            if ((length_ith_list = 0 ) orelse (length_ith_list = 2)) then corona (length-1) (i+1) adjList else false
        end

    (*prints list*)
    fun printList [x] = if (x = 0) then () else print(Int.toString(x))
      | printList (x::xs) = if (x = 0) then printList xs else (print(Int.toString(x)^" ");printList xs)

    (*sorts list*)
    fun sort list = ListMergeSort.sort (op >) list;

    (*checks the visited list if all elements are true, then its connected, if not they're not.*)
    fun check 1 i list = true
      | check length i list = 
        let
            val ith_elem = Array.sub(list,i)
        in
            if (ith_elem = true ) then check (length-1) (i+1) list else false
        end

    (*DFS algorithm to update the visited list. Starts from node n and marks any node that can be visited from that node.*)
    fun DFS adjList visited [] = visited
      | DFS adjList visited (x::xs) =
        if Array.sub(visited,x) = true then DFS adjList visited xs
        else let
            val upd_visited = Array.update(visited,x,true);
            val sublist_x_pos = Array.sub(adjList,x);
            val upd_tobeVisited = sublist_x_pos@xs;
        in
            DFS adjList (upd_visited;visited) upd_tobeVisited
        end

    fun run list n = 
        let 
            val adjacencyList = addInput list n;
            val visited_list = (empty_list_of (n+1) false);
            val tobeVisited = Array.sub(adjacencyList,n);
            val connected = DFS adjacencyList visited_list tobeVisited;
            val length_connected = Array.length(connected);
            val check_connected = check length_connected 1 connected;
        in
        if (check_connected) then
            let
            val len_list = (empty_list_of (n+1) 1);
            val (cutEdges_adjList,len_list_upd,cycles) = (cutEdge (adjacencyList,len_list,n) 1 n);
            val len_list_sorted = sort(List.tl(Array.toList(len_list_upd)));
            val length = Array.length(cutEdges_adjList);
            in
              if (corona length 1 cutEdges_adjList andalso cycles >= 3) then (print("CORONA " ^ Int.toString(cycles) ^"\n");(printList len_list_sorted);print("\n")) else print("NO CORONA\n")
            end
        else print("NO CORONA\n")
        end
in
  fun coronograph fileName = 
    let
      fun readInt input = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
      val inStream = TextIO.openIn fileName
      val graphs = readInt inStream
      fun parse inStream =
        let
            val n = readInt inStream
            val m = readInt inStream
            fun readInts 0 acc = List.rev acc
              | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
        in
            (readInts (2*m) [],n,inStream)
        end
      fun parsing graphs file = 
        if (graphs <> 0) then
            let val (list,n,inStream) = parse inStream
            in
              ((run list n);(parsing (graphs-1) inStream))
            end
        else ();
    in
      parsing graphs inStream
    end 
end
