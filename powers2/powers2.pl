% http://www.dbnet.ece.ntua.gr/~adamo/csbooksonline/prolog-notes.pdf --> page 88-89 got reverse code.

binary(0,[0]).
binary(1,[1]).
binary(Dec,BinList) :- Dec > 1, X is Dec mod 2,Y is Dec // 2,binary(Y,L1),BinList = [X|L1].

% a predicate to count the sum of all digits.
count([X],X).
count([X|Y],Z) :- count(Y,Z1), Z is X + Z1.

solveAux(HeadList,TailList,MinK,K,Res) :- 
    (MinK = K) -> append(HeadList,TailList,Final),rev(Final,RevFinal),cutZeros(RevFinal,NoZeros) ,Res = NoZeros.
solveAux(HeadList,[X,Y|TailListRest],MinK,K,Res) :- 
   Y >= 1 -> NewX is X + 2, NewY is Y - 1, NewMinK is MinK + 1,
append(HeadList,[NewX],UpdHeadList),append([NewY],TailListRest,UpdTailListRest),
append(UpdHeadList,UpdTailListRest,UpdLista),solveAux([],UpdLista,NewMinK,K,Res)
   ; append(HeadList,[X],UpdHeadList),append([Y],TailListRest,UpdTailListRest),
   solveAux(UpdHeadList,UpdTailListRest,MinK,K,Res).

% a predicate which is basicly the solver of this problem. If K>N or MinK > K then result is []
% if K is MinK then result is the binary list, else predicate solve "calls" solveAux 
solve(N,K,Result) :- binary(N,BinList),count(BinList,MinK), (
                     (K > N) | (MinK > K) -> Result = [] 
                  ;  (K = MinK) -> Result = BinList 
                  ; solveAux([],BinList,MinK,K,Res) -> Result = Res).

% reverse.
accRev([H|T],A,R) :- accRev(T,[H|A],R).
accRev([],A,A).

rev(L,R) :- accRev(L,[],R).
% end of reverse.

% Cut extra zeros.
cutZeros([X|Xs],NonZeroList) :-
   (X = 0) -> cutZeros(Xs,NonZeroList)
   ; rev([X|Xs],Rev),NonZeroList = Rev.

% Reads input.
read_rest(Stream,C,Ans,Final) :- 
    read_line(Stream,[N,K]),solve(N,K,Result),append(Ans,[Result],UpdAns),
    (C > 1 ->  NewC is C - 1,read_rest(Stream,NewC,UpdAns,Final) ; Final = UpdAns).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

powers2(File,Answers) :- open(File,read,Stream),read_line(Stream,C),read_rest(Stream,C,[],Answers),!.
