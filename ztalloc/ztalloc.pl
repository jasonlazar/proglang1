%Το κατηγόρημα app είναι το app_dl4 από το https://pdfs.semanticscholar.org/080b/8ff48a5069ea2d69f12e0ea397ed4c7e1482.pdf?fbclid=IwAR0wEtb_CS9Y-_y-cY4mC2T5q0KuHHd95Ju7sLBmCjDQ86mOwEP2sN0tjrM

ztalloc(File, Answer) :-
    read_input(File, L),
    solution(L, Answer),
    !.

read_input(File, L) :-
    open(File,read,Stream),
    read_line_to_codes(Stream,Line),
    number_codes(Q,Line),
    read_next(Stream, Q, L).

read_next(_,0,[]).
read_next(Stream,Q,[First|Rest]) :-
    read_line_to_codes(Stream,Line),
    atom_codes(Atoms,Line),
    atomic_list_concat(Atom,' ',Atoms),
    maplist(atom_number, Atom, First),
    NQ is Q-1,
    read_next(Stream, NQ, Rest),
    !.

solve(Lout, Rout, [Answer-Sofar| _]-_, _, Answer) :-
    \+ var(Sofar),
    maplist(more_or_equal(Lout), Sofar),
    maplist(less_or_equal(Rout), Sofar),
    !.

solve(Lout, Rout, [Path-Sofar|Next]-N, Assoc, Answer) :-
    \+ var(Sofar),
    maplist(halve, Sofar, HS),
    (\+ get_assoc(HS, Assoc, _) ->
        put_assoc(HS, Assoc, 0, Temp),
        HQueue = [[h|Path]-HS]
    ;
        Temp = Assoc,
        HQueue = []
    ),
    maplist(triple, Sofar, TS),
    (
    (\+ get_assoc(TS, Temp, _),
    maplist(less_or_equal(999999), TS) ) ->
        put_assoc(TS, Temp, 0, NAssoc),
        TQueue = [[t|Path]-TS]
    ;
        NAssoc = Temp,
        TQueue = []
    ),
    append(HQueue, TQueue, Q),
    append(Q, L, QL),
    app(Next-N, QL-L, Queue-Tail),
    solve(Lout, Rout, Queue-Tail, NAssoc, Answer).

solution([],[]).
solution([[Lin, Rin, Lout, Rout]|Next], [First|Rest]):-
    (solution(Lin, Rin, Lout, Rout, Answer) ->
        (Answer == [] ->
            First = 'EMPTY'
        ;
            reverse(Answer, RA),
            atom_chars(First, RA)
        )
    ;
        First = 'IMPOSSIBLE'
    ),
    solution(Next, Rest).

solution(Lin, Rin, Lout, Rout, Answer) :-
    Lin =\= Rin ->
        solve(Lout, Rout, [[]-[Lin, Rin]|N]-N, t, Answer)
    ;
        solve(Lout, Rout, [[]-[Lin]|N]-N, t, Answer).

halve(X, Y) :-
    Y is X div 2.

triple(X,Y) :-
    Y is X * 3 + 1.

less_or_equal(X, Y) :-
    Y =< X.

more_or_equal(X, Y) :-
    Y >= X.

app(A-B,B-C,A-C).
