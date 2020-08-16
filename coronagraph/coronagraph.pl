%https://stackoverflow.com/questions/15028831/how-do-you-append-an-element-to-a-list-in-place-in-prolog
add_tail([],X,[X]).
add_tail([H|T],X,[H|L]):-add_tail(T,X,L).

%https://stackoverflow.com/questions/15926034/how-to-merge-lists-in-prolog
merge_list([],L,L ).
merge_list([H|T],L,[H|M]):-merge_list(T,L,M).

%creates an empty list of Elements with Value of size Number
create_empty_list(List,Value,Number,Result) :- 
(Number > 0) -> add_tail(List,Value,UpdList),NewNum is Number - 1,create_empty_list(UpdList,Value,NewNum,Result) ; Result = List.

%insert the elements in the adjList
insert_elements(AdjList,U,V,UpdList) :- 
nth0(U, AdjList, SubList, Rest),add_tail(SubList,V,UpdSublist),nth0(U,UpdList,UpdSublist,Rest).

%add the edjes in the adjList with calling insert_elements
add_edge(U,V,AdjList,Final) :- insert_elements(AdjList,U,V,UpdAdjList_U),insert_elements(UpdAdjList_U,V,U,Final).

%used for adding edjes
add_edge_aux([],AdjList,Result) :- AdjList = Result.
add_edge_aux([X,Y|Z],AdjList,Result) :- add_edge(X,Y,AdjList,UpdAdj),add_edge_aux(Z,UpdAdj,Result).

%dfs algorithm to see if the graph is connected or not
dfs(_,Visited,[],Result) :- Result = Visited.
dfs(AdjList,Visited,[X|XS],Result) :-
    nth0(X,Visited,Elem), Elem = true -> dfs(AdjList,Visited,XS,Result)
    ; nth0(X,Visited,_,Rest),nth0(X,UpdVisited,true,Rest),
     nth0(X,AdjList,SubList_X_Pos),merge_list(SubList_X_Pos,XS,M),dfs(AdjList,UpdVisited,M,Result),!.

%predicate to check if is Corona or not
isCorona([],Ans) :- Ans = true.
isCorona([X|Rest],Ans) :- length(X,LengthX), (LengthX = 1 | LengthX > 2) -> Ans = false ; isCorona(Rest,Ans).

%auxilary function of cutedge, which cuts edges until the circle is left
cutEdgeAux(AdjList,LengthList,Cycles,Sublist_Index,Result) :-
    nth0(Sublist_Index,AdjList,Sublist),length(Sublist, Sublist_Length), Sublist_Length = 1 ->
    nth0(0,Sublist,ToBeRemoved),nth0(ToBeRemoved,AdjList,OpList),select(Sublist_Index,OpList,UpdOpList),
    select(ToBeRemoved,Sublist,UpdSublist),nth0(Sublist_Index,AdjList,_,Rest),nth0(Sublist_Index,UpdAdjV1,UpdSublist,Rest),
    nth0(ToBeRemoved,UpdAdjV1,_,Rest1),nth0(ToBeRemoved,FinalAdjList,UpdOpList,Rest1),
    nth0(ToBeRemoved,LengthList,FatherWeight),nth0(Sublist_Index,LengthList,ChildWeight),
    UpdWeight is FatherWeight + ChildWeight, nth0(ToBeRemoved,LengthList,_,Rest2),
    nth0(ToBeRemoved,LengthListV1,UpdWeight,Rest2),nth0(Sublist_Index,LengthListV1,_,Rest3),
    nth0(Sublist_Index,FinalLengthList,0,Rest3),UpdCycles is Cycles - 1,
    cutEdgeAux(FinalAdjList,FinalLengthList,UpdCycles,ToBeRemoved,Result) ; Result = [AdjList,LengthList,Cycles].
    
%cutedge function. Works with the help of cutEdgeAux
cutEdge(AdjList,LengthList,Cycles,_,0,Result) :- Result = [AdjList,LengthList,Cycles].
cutEdge(AdjList,LengthList,Cycles,Sublist_Index,Vertices,Result) :-
    cutEdgeAux(AdjList,LengthList,Cycles,Sublist_Index,[X,Y,Z]),UpdSublist_Index is Sublist_Index +1,
    UpdVertices is Vertices -1,cutEdge(X,Y,Z,UpdSublist_Index,UpdVertices,Result),!.

%checks if the result of dfs is connected or not
connected([],Ans) :- Ans = true.
connected([X|XS],Ans) :- X = false -> Ans = false ; connected(XS,Ans).

cutZeros([H|R],TnoZeros) :- H = 0 -> cutZeros(R,TnoZeros) ; TnoZeros = [H|R].

% main which calls all other predicates
run(List,Vertices,Result) :- N is Vertices + 1,create_empty_list([],[],N,EmptyAdjList),add_edge_aux(List,EmptyAdjList,AdjList), 
            create_empty_list([],false,N,Visited),
            nth0(0,Visited,_,Rest),nth0(0,CorrectVisited,true,Rest),
            nth0(Vertices,AdjList,ToBeVisited),
            dfs(AdjList,CorrectVisited,ToBeVisited,Connected),connected(Connected,IsConnected),
            ((IsConnected = false) -> Result = "'NO CORONA'"
            ; create_empty_list([],1,N,LengthList),nth0(0,LengthList,_,Rest1),nth0(0,CorrectLength,0,Rest1),
            cutEdge(AdjList,CorrectLength,Vertices,1,Vertices,[UpdAdjList,UpdLengthList,UpdCycles]),msort(UpdLengthList,Sorted),
            isCorona(UpdAdjList,Ans), Ans = true -> cutZeros(Sorted,SnoZeros),Result = [UpdCycles,SnoZeros] ; Result = "'NO CORONA'").

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

read_graph(Stream,M,List,Final) :- M > 0 -> read_line(Stream,Line),
    merge_list(List,Line,Merged),NewM is M - 1,read_graph(Stream,NewM,Merged,Final).
read_graph(_,0,List,Final) :- Final = List.

read_all_graphs(Stream,C,Answer,Final) :- 
    C > 0 -> read_line(Stream,[N,M]),read_graph(Stream,M,[],List),
    run(List,N,Result),NewC is C - 1,append(Answer,[Result],UpdAns),
    read_all_graphs(Stream,NewC,UpdAns,Final) ; Final = Answer.
        

coronograph(File,Answers) :- open(File,read,Stream),read_line(Stream,C),
        nth0(0,C,NumC),read_all_graphs(Stream,NumC,[],Answers),!.