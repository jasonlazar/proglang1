% Η read_line και η read_input είναι παραλλαγή αυτών στο http://courses.softlab.ntua.gr/pl1/2019a/Exercises/read_colors_SWI.pl

lottery(File, L) :-
	read_input(File, _K, _N, Q, T, List),
	makelist(T, List, Q, [], L).
	

trie_empty(Trie) :-
	Trie = root(0, []).

trieInsert(Trie, Key, T) :-
	atom_chars(Key, CharList),
	insert2(Trie, CharList, T).

insert2(root(V, Lst), [], T) :-
	NV is V+1,
	T = root(NV, Lst),
	!.

insert2(root(Elem, Lst), Key, T) :-
	insertChild(Lst, Key, L),
	T = root(Elem, L),
	!.

insert2(node(_, Letter, Lst), [], T) :-
	T = node(1, Letter, Lst),
	!.

insert2(node(Elem, Letter, Lst), Key, T) :-
	insertChild(Lst, Key, L),
	NE is Elem+1,
	T = node(NE, Letter, L),
	!.

insertChild([], [Letter], L) :-
	L = [node(1, Letter, [])],
	!.

insertChild([], [Letter|Rest], L) :-
	insertChild([], Rest, Lst),
	L = [node(1, Letter, Lst)],
	!.

insertChild([node(V, Lett, List) | Lst], [Letter|Rest], L) :-
	(Letter == Lett ->
		insert2(node(V, Lett, List), Rest, T),
		L = [T|Lst],
		!
	;
		insertChild(Lst, [Letter|Rest], NL),
		L = [node(V, Lett, List) | NL],
		!
	),
	!.

earnings(Trie, Clist, Ans) :-
	profit(Trie, Clist, 0, 0, 0, 0, Ans).

profit(root(_,_), [], _, _, _, _, [0, 0]).

profit(root(_, Lst), Clist, Count, Sum, Depth, _, Ans) :-
	ND is Depth+1,
	gains(Lst, Clist, Count, Sum, ND, 0, Ans),
	!.

profit(node(Elem,_,_), [], Count, Sum, Depth, Prev, [Count, S]) :-
	(Prev =:= 0 ->
		S is (Sum + Elem * ((2**Depth) -1)) mod 1000000007
	;
		S is (Sum + Elem * ((2**Depth) -1) + (Prev - Elem) * (2**(Depth-1) -1)) mod 1000000007
	),
	!.

profit(node(Elem, _, Lst), Clist, Count, Sum, Depth, Prev, Ans) :-
	NS is Sum + (Prev - Elem) * (2**(Depth-1) -1),
	ND is Depth+1,
	gains(Lst, Clist, Count, NS, ND, Elem, Ans),
	!.

gains([], _, Count, Sum, Depth, Prev, [Count, S]) :-
	S is (Sum + Prev * (2**(Depth-1) -1)) mod 1000000007,
	!.

gains([node(Elem, Lett, List) | Lst], [Letter|Rest], Count, Sum, Depth, Prev, Ans) :-
	(Lett == Letter ->
		(Prev =:= 0 ->
			profit(node(Elem, Lett, List), Rest, Elem, Sum, Depth, Elem, Ans)
		;
			profit(node(Elem, Lett, List), Rest, Count, Sum, Depth, Prev, Ans)
		)
	;
		gains(Lst, [Letter|Rest], Count, Sum, Depth, Prev, Ans)
	),
	!.

read_input(File, K, N, Q, T, L) :-
	open(File, read, Stream),
	read_line(Stream, [K, N, Q]),
	trie_empty(Trie),
	create_trie(Stream, N, Trie, T),
	read_lines(Stream, Q, [], L).

read_line(Stream, L) :-
	read_line_to_codes(Stream, Line),
	atom_codes(Atom, Line),
	atomic_list_concat(Atoms, ' ', Atom),
	maplist(atom_number, Atoms, L).

read_lines(_, 0, L, L).
read_lines(Stream, N, Acc, L) :-
	read_line_to_codes(Stream, Line),
	atom_codes(Atom, Line),
	atom_chars(Atom, C),
	reverse(C, NC),
	NN is N-1,
	read_lines(Stream, NN, [NC|Acc], L),
	!.

create_trie(_, 0, T, T).
create_trie(Stream, N, Trie, Tr) :-
	read_line_to_codes(Stream, Line),
	atom_codes(Atom, Line),
	atom_chars(Atom, C),
	reverse(C, NC),
	NN is N-1,
	insert2(Trie, NC, T),
	create_trie(Stream, NN, T, Tr),
	!.

makelist(_Trie, _List, 0, L, L).
makelist(Trie, [Head|Tail], Q, Acc, L) :-
	earnings(Trie, Head, Top),
	NQ is Q-1,
	makelist(Trie, Tail, NQ, [Top|Acc], L),
	!.
