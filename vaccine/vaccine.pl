%reverse.
accRev([H|T],A,R) :- accRev(T,[H|A],R).
accRev([],A,A).

rev(L,R) :- accRev(L,[],R).
%end of reverse.

auxbestPath([],TempPath,TempPath).
auxbestPath([(_,_,Path)|T],TempPath,Final):-
    string_length(Path, PathLength),string_length(TempPath,TempPathLength),
    (PathLength<TempPathLength | (PathLength=:=TempPathLength, Path @< TempPath))
    -> auxbestPath(T,Path,Final) ; auxbestPath(T,TempPath,Final).
    
bestPath([(_,_,Path)|T],Ans):- auxbestPath(T,Path,Ans).

%a predicate to change A <--> U and C <--> G.
comp(CLet,Complement) :- 
      CLet = 'A' -> Complement = 'U'
    ; CLet = 'U' -> Complement = 'A'
    ; CLet = 'G' -> Complement = 'C'
    ; CLet = 'C' -> Complement = 'G'.

%predicate that makes the move. Gets right stack and the current letter.
%if the right stack is empty just return the current letter.
%else if the highest in stack is equal to the current letter that is going to be in stack return only the stack
%else return the addition of current letter top of the stack
move(Right,CurLetter,NewRight) :-
    Right = [] -> NewRight = [CurLetter]
    ; [HeadRight|_] = Right,HeadRight = CurLetter -> NewRight = Right
    ; append([CurLetter], Right, NewRight).

%predicate to check if the move (that predicate move did) is valid. In this algorithm we keep only
%the 4 letters (A,C,G,U) - no dublicates. So the length can not be greater that 4. Also the right stack 
%can not be empty.
%if the first check is passed then we need to check the first letter(top of stack) with all the others so as it 
%is different. If equal then false. We do the same thing(same check) but starting from the end of the string and
%checking it with all the others if different. If not then false. The reason we do this is because valid predicate
%checks all moves(either is reversed or not).
valid([],true).
valid([RightHead|RightRest],IsValid) :- length(RightRest, RightLength),
    (RightLength>3 | member(RightHead,RightRest)) -> IsValid = false ; IsValid = true.

%predicate that makes the current letter. If left flag is equal to one, then we need to make the complement of the letter else not.
curLetterMaker(LeftFlag,SavedcurLetter,CurLetter):- LeftFlag = 1 -> comp(SavedcurLetter,Comp_SavedcurLetter), CurLetter = Comp_SavedcurLetter ; CurLetter = SavedcurLetter.

%predicate that does the cp move
cp(ChildrenCounter,RestS,ListRight,CurLetter,Path,LeftFlag,NewChildrenCounter,Upd_S):-
    (ListRight \= [] -> ( 
        comp(CurLetter,Comp_CurLetter),move(ListRight,Comp_CurLetter,NewRight),valid(NewRight,IsValid),
        (IsValid = true -> (
            atom_concat(Path,'cp',NewPath),Upd_LeftFlag is 1-LeftFlag, NewState = [(Upd_LeftFlag,NewRight,NewPath)],
            append(RestS,NewState,Upd_S),NewChildrenCounter is ChildrenCounter + 1)
        ; Upd_S = RestS, NewChildrenCounter = ChildrenCounter)
    ); Upd_S = RestS, NewChildrenCounter = ChildrenCounter ).

%predicate that makes the crp move
crp(ChildrenCounter,RestS,ListRight,CurLetter,Path,LeftFlag,NewChildrenCounter,Upd_S):-
    length(ListRight, LengthRight),
    (LengthRight > 1 -> ( 
        rev(ListRight,RevRight),comp(CurLetter,Comp_CurLetter),move(RevRight,Comp_CurLetter,NewRight),valid(NewRight,IsValid),
        (IsValid = true -> (
            atom_concat(Path,'crp',NewPath),Upd_LeftFlag is 1-LeftFlag, NewState = [(Upd_LeftFlag,NewRight,NewPath)],
            append(RestS,NewState,Upd_S),NewChildrenCounter is ChildrenCounter + 1)
        ; Upd_S = RestS, NewChildrenCounter = ChildrenCounter)
    ); Upd_S = RestS, NewChildrenCounter = ChildrenCounter ).

%predicate that makes the p move
p(ChildrenCounter,RestS,ListRight,CurLetter,Path,LeftFlag,NewChildrenCounter,Upd_S):-
    move(ListRight,CurLetter,NewRight),valid(NewRight,IsValid),
    (IsValid = true -> (
        atom_concat(Path,'p',NewPath), NewState = [(LeftFlag,NewRight,NewPath)],
        append(RestS,NewState,Upd_S),NewChildrenCounter is ChildrenCounter + 1)
    ; Upd_S = RestS, NewChildrenCounter = ChildrenCounter).

%predicate that makes the rp move
rp(ChildrenCounter,RestS,ListRight,CurLetter,Path,LeftFlag,NewChildrenCounter,Upd_S):-
    length(ListRight, LengthRight),
    (LengthRight > 1 -> ( 
        rev(ListRight,RevRight),move(RevRight,CurLetter,NewRight),valid(NewRight,IsValid),
        (IsValid = true -> (
            atom_concat(Path,'rp',NewPath),NewState = [(LeftFlag,NewRight,NewPath)],
            append(RestS,NewState,Upd_S),NewChildrenCounter is ChildrenCounter + 1)
        ; Upd_S = RestS, NewChildrenCounter = ChildrenCounter)
    ); Upd_S = RestS, NewChildrenCounter = ChildrenCounter ).


for_Statement(CurChCounter,I,[HeadS|RestS],SavedcurLetter,ChildrenCounter,Result) :- 
    I = CurChCounter -> Result = [[HeadS|RestS],ChildrenCounter]
    ;(  
        (LeftFlag,Right,Path) = HeadS, 
        atom_codes(ToListRight,Right),atom_chars(ToListRight,ListRight),
        curLetterMaker(LeftFlag,SavedcurLetter,CurLetter),
        
        cp(ChildrenCounter,RestS,ListRight,CurLetter,Path,LeftFlag,ChildrenCounterCP,Upd_S_CP),
        crp(ChildrenCounterCP,Upd_S_CP,ListRight,CurLetter,Path,LeftFlag,ChildrenCounterCRP,Upd_S_CRP),
        p(ChildrenCounterCRP,Upd_S_CRP,ListRight,CurLetter,Path,LeftFlag,ChildrenCounterP,Upd_S_P),
        rp(ChildrenCounterP,Upd_S_P,ListRight,CurLetter,Path,LeftFlag,ChildrenCounterRP,Upd_S_RP),

        NewI is I + 1,
        for_Statement(CurChCounter,NewI,Upd_S_RP,SavedcurLetter,ChildrenCounterRP,Result)
    ).

%predicate which solves the problem with the help of the predicate for_Statement.
solve([],_,S,Path) :- bestPath(S,BestPath), Path = BestPath.
solve([SavedcurLetter|Left],ChildrenCounter,S,Path) :- for_Statement(ChildrenCounter,0,S,SavedcurLetter,0,[NewS,NewCC]),solve(Left,NewCC,NewS,Path).

%predicate which reads the rest of the input (after the first line which is how many inputs are given)
read_rest(Stream,C,Ans,Final) :- 
    read_line(Stream,RNA),rev(RNA,RevRNA),solve(RevRNA,1,[(0,"","")],Path),append(Ans,[Path],UpdAns),
    (C > 1 ->  NewC is C - 1,read_rest(Stream,NewC,UpdAns,Final) ; Final = UpdAns).

%predicate which reads one line. Converts the input to an array of characters.
read_line(Stream, L) :- read_line_to_codes(Stream, Line), atom_codes(Atom, Line), atom_chars(Atom, L).

vaccine(File,Answers) :- open(File,read,Stream),read_line(Stream,HC),number_string(C,HC),read_rest(Stream,C,[],Answers),maplist(writeln,Answers),!.
