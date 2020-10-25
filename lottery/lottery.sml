local

fun powerof2 n =
  let 
     fun power2 (0, acc) = acc
	| power2 (n, acc) = power2 (n-1, Int.fromLarge((Int.toLarge(acc mod 1000000007) + Int.toLarge(acc mod 1000000007)) mod 1000000007)) 
  in
     power2 (n, 1)
  end

(* Ο κώδικας για τα tries είναι από το https://github.com/jlao/sml-trie/blob/master/trie.sml*)

(* Signature for dictionaries *)
(*
   For simplicity, we assume keys are strings, while stored entries
   are of arbitrary type.  This is prescribed in the signature.
   Existing entries may be "updated" by inserting a new entry
   with the same key.
*)

signature DICT =
sig
  type key = string                 (* concrete type *)
  type entry = key * int          (* concrete type *)

  type dict                      (* abstract type *)

  val empty : dict
  val lookup : dict -> key -> int option
  val insert : dict * entry -> dict
  val toString : (int -> string) -> dict -> string
  val earnings : dict * key -> string
end;  (* signature DICT *)

exception InvariantViolationException

structure Trie :> DICT = 
struct
  type key = string
  type entry = key * int

  datatype trie = 
    Root of int option * trie list
  | Node of int option * char * trie list

  type dict = trie

  val empty = Root(NONE, nil)

  (* val lookup: int dict -> key -> int option *)
  fun lookup trie key =
    let
      (* val lookupList: int trie list * char list -> int option *)
      fun lookupList (nil, _) = NONE
        | lookupList (_, nil) = raise InvariantViolationException
        | lookupList ((trie as Node(_, letter', _))::lst, key as letter::rest) =
            if letter = letter' then lookup' (trie, rest)
            else lookupList (lst, key)
        | lookupList (_, _) =
            raise InvariantViolationException

      (*
        val lookup': int trie -> char list
      *)
      and lookup' (Root(elem, _), nil) = elem
        | lookup' (Root(_, lst), key) = lookupList (lst, key)
        | lookup' (Node(elem, _, _), nil) = elem
        | lookup' (Node(elem, letter, lst), key) = lookupList (lst, key)
    in
      lookup' (trie, explode key)
    end
 	
  (*
    val insert: int dict * int entry -> int dict
  *)
  fun insert (trie, (key, value)) = 
    let
      (*
        val insertChild: int trie list * key * value -> int trie list
        Searches a list of tries to insert the value. If a matching letter 
        prefix is found, it peels of a letter from the key and calls insert'. 
        If no matching letter prefix is found, a new trie is added to the list.
        Invariants:
          * key is never nil.
          * The trie list does not contain a Root.
        Effects: none
      *)
      fun insertChild (nil, letter::nil, value) = 
            [ Node(SOME(1), letter, nil) ]
        | insertChild (nil, letter::rest, value) = 
            [ Node(SOME(1), letter, insertChild (nil, rest, value)) ]
        | insertChild ((trie as Node(_, letter', _))::lst, key as letter::rest, value) = 
            if letter = letter' then
              insert' (trie, rest, value) :: lst
            else
              trie :: insertChild (lst, key, value)
        | insertChild (Root(_,_)::lst, letter::rest, value) =
            raise InvariantViolationException
        | insertChild (_, nil, _) = (* invariant: key is never nil *)
            raise InvariantViolationException

      (*
        val insert': int trie * char list * int -> int trie
        Invariants:
          * The value is on the current branch, including potentially the current node we're on.
          * If the key is nil, assumes the current node is the destination.
        Effects: none
      *)
      and insert' (Root(_, lst), nil, value) = Root(SOME(value), lst)
        | insert' (Root(elem, lst), key, value) = Root(elem, insertChild (lst, key, value))
        | insert' (Node(_, letter, lst), nil, value) = Node(SOME(1), letter, lst)
        | insert' (Node(elem, letter, lst), key, value) = 
		case elem of NONE => Node(SOME(1), letter, insertChild (lst, key, value))
			| SOME(i) => Node(SOME(i+1), letter, insertChild (lst, key, value))
    in
      insert'(trie, explode key, value)
    end

    (*
      val toString: (int -> string) -> int dict -> string
    *)
    fun toString f trie =
      let
        val prefix = "digraph trie {\nnode [shape = circle];\n"
        val suffix = "}\n"

        (* val childNodeLetters: int trie list * char list -> char list *)
        fun childNodeLetters (lst, id) =
          (foldr 
            (fn (Node(_, letter, _), acc) => letter::acc
              | _ => raise InvariantViolationException) nil lst)

        (* val edgeStmt: string * string * char -> string *)
        fun edgeStmt (start, dest, lbl) =
          start ^ " -> " ^ dest ^ " [ label = " ^ Char.toString(lbl) ^ " ];\n"

        (* val allEdgesFrom: char list * char list *)
        fun allEdgesFrom (start, lst) = 
          (foldr 
            (fn (letter, acc) => 
              acc ^ edgeStmt(implode(start), implode(start @ [letter]), letter))
            "" lst)

        (* val labelNode: stirng * string -> string *)
        fun labelNode (id: string, lbl: string) =
          id ^ " [ label = \"" ^ lbl ^ "\" ];\n"

        fun toString' (Root(elem, lst), id) =
              let
                val idStr = implode(id)
                val childLetters = childNodeLetters(lst, id)
                val childStr = foldr (fn (trie, acc) => acc ^ toString'(trie, id)) "" lst
              in
                (case elem
                  of SOME(value) => 
                      labelNode (idStr, f(value)) ^ 
                      allEdgesFrom (id, childLetters)
                   | NONE => 
                      labelNode (idStr, "") ^ 
                      allEdgesFrom (id, childLetters)) ^ childStr
              end
          | toString' (Node(elem, letter, lst), id) =
              let
                val thisId = id @ [letter]
                val idStr = implode(thisId)
                val childLetters = childNodeLetters(lst, thisId)
                val childStr = foldr (fn (trie, acc) => acc ^ toString'(trie, thisId)) "" lst
              in
                (case elem
                  of SOME(value) => 
                      labelNode (idStr, f(value)) ^ 
                      allEdgesFrom (thisId, childLetters)
                   | NONE => 
                      labelNode (idStr, "") ^ 
                      allEdgesFrom (thisId, childLetters)) ^ childStr
              end
      in
        prefix ^ (toString' (trie, [#"_", #"R"])) ^ suffix
      end

   fun earnings (t, numbers) =
	   let
	      fun gains(nil, _, count, sum, depth, prev) = Int.toString(count) ^ " " ^ Int.toString(Int.fromLarge((Int.toLarge(sum mod 1000000007) + ((Int.toLarge(prev)*Int.toLarge(((powerof2 (depth-1)) -1))) mod 1000000007)) mod 1000000007)) ^ "\n"
		| gains((trie as Node(elem, letter', _))::lst, key as letter::rest, count, sum, depth, prev) =
			if letter = letter' then case prev of 0 => profit (trie, rest, Option.valOf(elem), sum, depth, Option.valOf(elem))
							| _ => profit (trie, rest, count, sum, depth, prev)
			else gains (lst, key, count, sum, depth, prev)

	      and profit (Root(_,_), nil, count, sum, depth, prev) = "0 0\n"
		| profit (Root(elem,lst), clist, count, sum, depth, prev) = gains (lst, clist, count, sum, depth+1, 0)
		| profit (Node(elem, _, _), nil, count, sum, depth, prev) =
			(case prev of 0 => Int.toString(count) ^ " " ^ Int.toString(Int.fromLarge(((Int.toLarge(sum mod 1000000007)) + ((Int.toLarge(Option.valOf(elem)) *Int.toLarge(((powerof2 depth) - 1)) mod 1000000007))) mod 1000000007)) ^ "\n"
			  | _ => Int.toString(count) ^ " " ^ Int.toString(Int.fromLarge((Int.toLarge(sum mod 1000000007) + (((Int.toLarge(Option.valOf(elem)) *Int.toLarge(((powerof2 depth) - 1)) mod 1000000007)) + (Int.toLarge((prev-Option.valOf(elem)))*Int.toLarge(((powerof2 (depth-1) -1)) mod 1000000007))) mod 1000000007) mod 1000000007)) ^ "\n")
		| profit (Node(elem, letter, lst), clist, count, sum, depth, prev) = gains(lst, clist, count, Int.fromLarge((Int.toLarge(sum) + (((Int.toLarge((prev-Option.valOf(elem))) * Int.toLarge((powerof2 (depth-1) -1)))) mod 1000000007)) mod 1000000007), depth+1, Option.valOf(elem))

	   in
	     profit (t, explode numbers, 0, 0, 0, 0)
	   end

end

fun parse file =
  let 
     val inStream = TextIO.openIn file
     fun readInt input = 
	    Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
     val k = readInt inStream
     val n = readInt inStream
     val q = readInt inStream
     val _ = TextIO.inputLine inStream
     fun helper (strlist, q) =
	let
	   fun reverse (copt, str) =
	      case copt of
		NONE => (TextIO.closeIn inStream; implode str)
	      | SOME(#"\n") => implode str
	      | SOME(c) => reverse (TextIO.input1 inStream, c::str)
	in
	  case q of 
	     0 => (TextIO.closeIn inStream; strlist)
	   | _ => helper((reverse(TextIO.input1 inStream, nil) :: strlist) , q-1)
	end
     fun createTrie (trie, n) =
	let
	   fun reverse (copt, str, k) = 
	      case k of
		0 => implode str
	      |	_ => reverse (TextIO.input1 inStream, Option.valOf(copt)::str, k-1)
	in
	  case n of
	     0 => trie
	   | _ => createTrie(Trie.insert(trie, ((reverse(TextIO.input1 inStream, nil, k)), 1)), n-1)
	end
  in
     (k, n, q, createTrie(Trie.empty,n), helper(nil, q))
  end

in

fun lottery filename =
  let
     val (k,n,q,t,l) = parse filename
     fun makelist (tr, lst, 0, out) = out
	| makelist (tr, lst, q, out) = makelist(tr, tl lst, q-1, Trie.earnings(tr, hd lst) :: out)
     fun printlist (lst, 1) = print (hd lst)
	| printlist (lst, q) = (print(hd lst); printlist (tl lst, q-1))
  in
     printlist (makelist(t,l,q,[]), q) 
  end

end
