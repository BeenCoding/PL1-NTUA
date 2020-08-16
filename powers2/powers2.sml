(*https://stackoverflow.com/questions/36799572/how-to-print-a-list απο εδω πηρα την printList *)
local
    (*function that gets a number and returns the binary in a list,LSB to MSB*)
    fun binary 0 = []
      | binary num = (num mod 2)::binary (num div 2);
    (*function that gets a list and returns the sum of digits of the list*)
    fun count [] = 0
      | count [x] = x
      | count (x::ys) = x + count ys;
    
    (*function that gets a list, numbers index that needs to be changed, current position 
    the number that needs to add at list[i] and accumulator list.*)
    fun update (x::ys) i position num acc =
      if(position = i) then
        (acc@ (List.foldr (op ::) ys [x+num]) )
      else
        update ys i (position + 1) num (List.foldr (op ::) [x] acc)

    (*solves the problem. Gets the number, the ith element of the list,k,the smallest number of 
    k's that the number needs so its represented in powers of 2 and the binary number as a list. 
    Checks if k is bigger than n or if k is smaller than the minimum number of powers of 2 to be
    represented. If any of the above checks returns true then empty list returned. Else if the ith element
    of the list is bigger or equal to 1 then solve function calls update function to update the ith 
    and (i-1)th element.After returning the updated list solve function calls itself with all the previous
    arguments but the updatedlist and the min_k plus 1. If nth element of the list is < 1 then solve function
    calls itself with the same arguments but with the ith element of the list + 1 so it keeps searching until
    it finds an element that matches the previous case. When k is equal to the min_k it returns the list, which is
    updated. Note: min_k at first call of the solve function is equal to the minimum number of powers of 2 that 
    number n needs to be represented in powers of 2. Each time the list is updated min_k++.*)
    fun solve n i k min_k lista  =
      if ((n < k) orelse (k < min_k)) then []
      else if ( k = min_k ) then List.rev lista
      else
        if (List.nth(lista,i) >= 1) then
          let
            val updatedlist = update ( update lista i 0 ~1 []) (i-1) 0 2 []
          in
            solve n 1 k (min_k+1) updatedlist
          end
        else solve n (i+1) k min_k lista

    (*function that gets a list and pops the extra zeros*)
    fun pop_zeros (x::ys) = if (x = 0) then pop_zeros ys else List.rev (x::ys)
      | pop_zeros [] = []

    (*function to parse the file into a tuple. first element of tuple is the number
    of couples will read and the second element is a list of all the couples*)
    fun parse file =
    let
        fun readInt input = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
        val inStream = TextIO.openIn file
        val n = readInt inStream
        val _ = TextIO.inputLine inStream
        fun readInts 0 acc =List.rev acc
          | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
    in
        (n-1,readInts (2*n) [])
    end
   
   (*function to print the list*)
   fun printList xs = (print("["); print(String.concatWith "," (map Int.toString xs)); print("]"); print ("\n"));

   (*function that gets the parsed file. In each iteration removes two elements from the hd.Every time 
   calls the functions that do the work, so it prints the resulsolvest every time and calls itself with the rest
   elements of the list.*)
   fun couplesList (0,[n,k]) = printList(pop_zeros (solve n 1 k (count (binary n)) (binary n)))
     | couplesList (couplesLeft,(n::k::rest)) = (printList(pop_zeros(solve n 1 k (count(binary n)) (binary n))); couplesList(couplesLeft-1,rest))
     
in
  fun powers2 fileName = couplesList(parse fileName)
end
