local
    (*we got the the fun linelist from : https://stackoverflow.com/questions/3918288/turning-a-string-into-a-char-list-list-using-sml*)
    fun linelist file =
        let val instr = TextIO.openIn file
            val str   = TextIO.inputAll instr
        in 
            String.tokens Char.isSpace str
            before
            TextIO.closeIn instr
        end;

    fun findAll globe n m = 
        let
            val sq = Queue.mkQueue(): (int * int) Queue.queue (*sotiris queue, with all possible positions of sotiris*)
            val aq = Queue.mkQueue(): (int * int) Queue.queue (*airport queue, with all possible positions of airport*)
            val vq = Queue.mkQueue(): (int * int) Queue.queue (*virus queue, with all possible positions of virus*)
            val target = Queue.mkQueue(): (int * int) Queue.queue (*This queue has only one element, which are the x,y pos of Target*)
            val sotiris = Queue.mkQueue(): (int * int) Queue.queue (*This queue has only one element, which are the x,y pos of Sotiris at start*)
            val activated = Queue.mkQueue(): int Queue.queue (*This queue has been used so as airports are activated*)
            val reached = Queue.mkQueue(): int Queue.queue (*This queue has only one element.When empty, either the Virus, or Sotiris reached Target*)
            
            (*add_active fun checks if activated queue has more than 1 and less than 10(so as the queue doesnt get very big(there is no reason))
            and adds to queue an element. Else leave it as is*)
            fun add_active activated = if (Queue.length(activated) > 1 andalso Queue.length(activated) < 10) then (Queue.enqueue(activated,1)) else ()
            val previous = Array2.array(n,m,"@")
            
            (*fun to remove a specific airport from the queue*)
            fun remove_airport aq (x:int) (y:int) = 
                let
                    val (x_aq,y_aq) = Queue.dequeue(aq)
                in
                    if(x_aq = x andalso y_aq = y) then ()
                    else (Queue.enqueue(aq,(x_aq,y_aq));remove_airport aq x y)
                end
            
            (*function to do the valid move*)
            fun validMove x y idx move = 
                if((x < 0) orelse (x >= n) orelse (y < 0) orelse (y >= m)) then ()
                else if (Array2.sub(globe,x,y) = #"X") then ()
                else if (idx = #"S" orelse idx = #"Z") then 
                    if (Array2.sub(globe,x,y) = #"T") then 
                        if (move > Array2.sub(previous,x,y)) then ((Queue.clear(reached));Array2.update(previous,x,y,move)) else ((Queue.clear(reached));Array2.update(previous,x,y,Array2.sub(previous,x,y)))
                    else if (Array2.sub(globe,x,y) = #".") then ((Array2.update(globe,x,y,#"S"));(Array2.update(previous,x,y,move));Queue.enqueue(sq,(x,y))) 
                    else if (Array2.sub(globe,x,y) = #"A") then ((Array2.update(globe,x,y,#"Z"));(Array2.update(previous,x,y,move));Queue.enqueue(sq,(x,y)))
                    else ()
                else if (idx = #"W") then
                    if (Array2.sub(globe,x,y) = #"T") then (Array2.update(globe,x,y,#"W");(Queue.clear(reached)))
                    else if (Array2.sub(globe,x,y) = #"S" orelse Array2.sub(globe,x,y) = #".") then (Array2.update(globe,x,y,#"W");Queue.enqueue(vq,(x,y)))
                    else if (Array2.sub(globe,x,y) = #"Z" orelse Array2.sub(globe,x,y) = #"A") then (Array2.update(globe,x,y,#"W");(Queue.enqueue(activated,1));(remove_airport aq x y);Queue.enqueue(vq,(x,y)))
                    else()
                else if (idx = #"I") then
                    if (Array2.sub(globe,x,y) = #"T") then (Array2.update(globe,x,y,#"I");(Queue.clear(reached)))
                    else if (Array2.sub(globe,x,y) = #"S" orelse Array2.sub(globe,x,y) = #".") then (Array2.update(globe,x,y,#"I");Queue.enqueue(aq,(x,y)))
                    else ()                
                else ()
            
            (*function to spread the virus to all directions.*)       
            fun spread x y = 
                let
                    val elem = Array2.sub(globe,x,y)
                in
                    (validMove (x+1) y elem "D");
                    (validMove x (y-1) elem "L");
                    (validMove x (y+1) elem "R");
                    (validMove (x-1) y elem "U")
                end
            
            (*fun which loops for virus queue*)
            fun trav_virus length_virus =
                if (length_virus > 0) then
                    let
                        val (x,y) = Queue.dequeue(vq)
                    in
                        ((spread x y); trav_virus (length_virus-1)) 
                    end
                else ()
            
            (*fun which loops for sotiris queue*)
            fun trav_s length_s = 
                if(length_s > 0 ) then
                    let
                        val (x,y) = Queue.dequeue(sq)
                        val temp = Array2.sub(globe,x,y)
                    in
                        if (temp = #"S" orelse temp = #"Z") then ((spread x y); trav_s (length_s-1))
                        else ((Array2.update(globe,x,y,#"S"));(spread x y);(Array2.update(globe,x,y,temp)); trav_s (length_s-1))
                    end
                else ()  
            
            (*fun which loops for airports queue*)      
            fun trav_air length_air =
                if (length_air > 0) then
                    let
                        val (x,y) = Queue.dequeue(aq)   
                        val curr = Array2.sub(globe,x,y)
                    in   
                        if(curr = #"A" orelse curr = #"Z" orelse curr = #"S") 
                        then (Array2.update(globe,x,y,#"I");Queue.enqueue(aq,(x,y));(trav_air (length_air-1))) 
                        else ((spread x y);(trav_air (length_air-1)))
                    end
                else ()
            
            (*print the path with the right order*)
            fun print_path [] = ()
            | print_path [x] = (print(x);print("\n"))
            | print_path (x::xs) = (print(x); print_path(xs))
        
            (*find the path and place it to a list, with the right order*)
            fun find_path x_s y_s x_t y_t path =
                if (x_t = x_s andalso y_t = y_s) then (print_path path)
                else
                    let
                        val el = Array2.sub(previous,x_t,y_t)
                        val path_upd = [el]@path
                    in
                        
                        if (el = "U") then (find_path x_s y_s (x_t+1) y_t path_upd)
                        else if (el = "D") then (find_path x_s y_s (x_t-1) y_t path_upd)
                        else if (el = "L") then (find_path x_s y_s x_t (y_t+1) path_upd)
                        else (find_path x_s y_s x_t (y_t-1) path_upd)
                    end
            
            (*basicly a while loop which keeps running while reached <> true. 
            Calls the trav_virus/trav_air/trav_s so as spread is done for virus/infected airports/sotiris*)
            fun traverse reached activated t = 
                let
                    val (x_s,y_s) = Queue.head(sotiris)
                    val (x_t,y_t) = Queue.head(target)
                in
                    if (Queue.isEmpty(reached)) then 
                        if(Array2.sub(previous,x_t,y_t) = "@") 
                        then (print("IMPOSSIBLE\n"))
                        else (print(Int.toString(t)^"\n");(find_path x_s y_s x_t y_t []))
                    else(
                        if (t mod 2 = 1) then ((add_active activated);(trav_virus (Queue.length(vq)));(trav_s (Queue.length(sq)));(traverse reached activated (t+1))) 
                        else if ((Queue.length(activated)>=6) andalso (t mod 2 = 0)) 
                            then ((add_active activated);(trav_air (Queue.length(aq)));(trav_s (Queue.length(sq)));(traverse reached activated (t+1))) 
                        else ((add_active activated);(trav_s (Queue.length(sq)));(traverse reached activated (t+1)))
                    )
                end
            
            (*Finds T/S/W/A and place each one of them to a queue.*)
            fun findAll_aux i j =
            if i >= n then (Queue.enqueue(activated,0);Queue.enqueue(reached,0);(traverse reached activated 0))
            else
                if j >= m then (findAll_aux (i+1) 0)
                else(
                    if Array2.sub(globe,i,j) = #"W" then Queue.enqueue(vq,(i,j))
                    else if Array2.sub(globe,i,j) = #"S" then (Queue.enqueue(sq,(i,j));Queue.enqueue(sotiris,(i,j)))
                    else if Array2.sub(globe,i,j) = #"T" then Queue.enqueue(target,(i,j))
                    else if Array2.sub(globe,i,j) = #"A" then Queue.enqueue(aq,(i,j))
                    else ();
                    (findAll_aux i (j+1)))
        in
            (findAll_aux 0 0) 
        end
in
    fun stayhome file  =  
        let
            val globe = List.map explode (linelist file)
            val n = length(globe)
            val m = length(hd (globe))
            val g = Array2.fromList(globe)
        in
            (findAll g n m)
        end
end