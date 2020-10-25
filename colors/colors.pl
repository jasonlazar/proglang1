% Για το διάβασμα του αρχεου χρησιμοποίηθηκε βοηθητικός κώδικας από το http://courses.softlab.ntua.gr/pl1/2019a/Exercises/read_colors_SWI.pl

read_input(File, N, K, C) :-
    open(File, read, Stream),
    read_line(Stream, [N, K]),
    read_line(Stream, C).

read_line(Stream, L) :-
    read_line_to_codes(Stream, Line),
    atom_codes(Atom, Line),
    atomic_list_concat(Atoms, ' ', Atom),
    maplist(atom_number, Atoms, L).

colors(File, Answer) :-
    read_input(File, N, K, C),
    create_empty_assoc(K, A),
    Min is N +1,
    solve(K, 0, C, C, A, 1, Min, Ans),
    (Ans =:= Min ->
        Answer is 0
    ;
        Answer is Ans
    ).

create_empty_list(K, L) :-
    create_empty_list(K, [], L).

create_empty_list(0, L, L).
create_empty_list(K, L1, L) :-
    NK is K-1,
    create_empty_list(NK, [K-0 | L1], L),
    !.

create_empty_assoc(K, A) :-
    create_empty_list(K, L),
    list_to_assoc(L, A).

solve(K, K, [First|FRest], [], A, Length, Ans, Min):-
    (Length =< Ans ->
        NL is Length-1,
        get_assoc(First, A, V),
        (V-1 =:= 0 ->
            Seen is K-1,
            put_assoc(First, A, 0, NA),
            solve(K, Seen, FRest, [], NA, NL, NL, Min),
            !
        ;
            NV is V-1,
            put_assoc(First, A, NV, NA),
            solve(K, K, FRest, [], NA, NL, NL, Min),
            !
        )
    ;
        NL is Length-1,
        get_assoc(First, A, V),
        (V-1 =:= 0 ->
            Seen is K-1,
            put_assoc(First, A, 0, NA),
            solve(K, Seen, FRest, [], NA, NL, Ans, Min),
            !
        ;
            NV is V-1,
            put_assoc(First, A, NV, NA),
            solve(K, K, FRest, [], NA, NL, Ans, Min),
            !
         )
    ),
    !.

solve(_K, _Seen, _, [], _A, _Length, Ans, Min):-
        Min is Ans,
        !.

solve(K, K, [First|FRest], [Last|LRest], A, Length, Ans, Min) :-	
    (Length =< Ans ->
        NL is Length-1,
        get_assoc(First, A, V),
        (V-1 =:= 0 ->
            Seen is K-1,
            put_assoc(First, A, 0, NA),
            solve(K, Seen, FRest, [Last|LRest], NA, NL, NL, Min),
            !
        ;
            NV is V-1,
            put_assoc(First, A, NV, NA),
            solve(K, K, FRest, [Last|LRest], NA, NL, NL, Min),
            !
        )
    ;
        NL is Length-1,
        get_assoc(First, A, V),
        (V-1 =:= 0 ->
            Seen is K-1,
            put_assoc(First, A, 0, NA),
            solve(K, Seen, FRest, [Last|LRest], NA, NL, Ans, Min),
            !
        ;
            NV is V-1,
            put_assoc(First, A, NV, NA),
            solve(K, K, FRest, [Last|LRest], NA, NL, Ans, Min),
            !
        )
    ),
    !.

solve(K, Seen, [First|FRest], [Last|LRest], A, Length, Ans, Min) :-
    NL is Length+1,
    get_assoc(Last,A,V),
    (V =:= 0 ->
        NS is Seen+1,
        put_assoc(Last, A, 1, NA),
        solve(K, NS, [First|FRest], LRest, NA, NL, Ans, Min),
        !
    ;
        NV is V+1,
        put_assoc(Last, A, NV, NA),
        solve(K, Seen, [First|FRest], LRest, NA, NL, Ans, Min),
        !
    ),
    !.
