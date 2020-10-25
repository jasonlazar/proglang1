local

(* O κώδικας για το stack και το queue είναι από το http://www.cs.cornell.edu/courses/cs312/2004sp/lectures/rec07.html με κάποιες τροποποιήσεις*)

signature STACK = 
    sig
      type 'a stack
      exception EmptyStack

      val empty : 'a stack
      val isEmpty : 'a stack -> bool

      val push : ('a * 'a stack) -> 'a stack
      val pop : 'a stack -> 'a stack
      val top : 'a stack -> 'a
      val map : ('a -> 'b) -> 'a stack -> 'b stack
      val app :  ('a -> unit) -> 'a stack -> unit
      (* note: app traverses from top of stack down *)
    end

structure Stack :> STACK = 
    struct
      type 'a stack = 'a list
      exception EmptyStack

      val empty : 'a stack = []
      fun isEmpty (l:'a list): bool = 
        (case l of
           [] => true
         | _ => false)

      fun push (x:'a, l:'a stack):'a stack = x::l
      fun pop (l:'a stack):'a stack = 
        (case l of 
           [] => raise EmptyStack
         | (x::xs) => xs)

      fun top (l:'a stack):'a = 
        (case l of
           [] => raise EmptyStack
         | (x::xs) => x)

      fun map (f:'a -> 'b) (l:'a stack):'b stack = List.map f l
      fun app (f:'a -> unit) (l:'a stack):unit = List.app f l
    end

signature QUEUE =
    sig
      type 'a queue
      exception EmptyQueue

      val empty : 'a queue
      val isEmpty : 'a queue -> bool

      val enqueue : ('a * 'a queue) -> 'a queue
      val dequeue : 'a queue -> 'a queue
      val front : 'a queue -> 'a

      val map : ('a -> 'b) -> 'a queue -> 'b queue
      val app : ('a -> unit) -> 'a queue -> unit      
    end

structure Queue :> QUEUE = 
    struct

      structure S = Stack

      type 'a queue = ('a S.stack * 'a S.stack)
      exception EmptyQueue

      val empty : 'a queue = (S.empty, S.empty)
      fun isEmpty ((s1,s2):'a queue) = 
        S.isEmpty (s1) andalso S.isEmpty (s2) 

      fun enqueue (x:'a, (s1,s2):'a queue) : 'a queue = 
        (S.push (x,s1), s2)

      fun rev (s:'a S.stack):'a S.stack = let
        fun loop (old:'a S.stack, new:'a S.stack):'a S.stack = 
          if (S.isEmpty (old))
            then new
          else loop (S.pop (old), S.push (S.top (old),new))
      in
        loop (s,S.empty)
      end

      fun dequeue ((s1,s2):'a queue) : 'a queue = 
        if (S.isEmpty (s2))
          then (S.empty, S.pop (rev (s1))) 
                    handle S.EmptyStack => raise EmptyQueue
        else (s1,S.pop (s2))

      fun front ((s1,s2):'a queue):'a = 
        if (S.isEmpty (s2))
          then S.top (rev (s1))
                   handle S.EmptyStack => raise EmptyQueue
        else S.top (s2)

      fun map (f:'a -> 'b) ((s1,s2):'a queue):'b queue = 
        (S.map f s1, S.map f s2)

      fun app (f:'a -> unit) ((s1,s2):'a queue):unit = 
        (S.app f s2;
         S.app f (rev (s1)))

    end

fun printtuple (a,b) =
	(print(Int.toString(a) ^ ", ");
	print(Int.toString(b) ^ "\n"))

fun comp ((a,b), (c,d)) =
   case (a > c) orelse (a = c andalso b > d) of true => GREATER
		| false => if a = c andalso b = d then EQUAL
			   else LESS
  
structure S = BinaryMapFn(struct
    type ord_key = int*int
    val compare = comp
  end)

fun parse file =
    let
      val inStream = TextIO.openIn file
      fun helper (copt, bmap, x, y, flood, cat) =
       case copt of
            NONE => (TextIO.closeIn inStream; (bmap, flood, cat))
          | SOME(#"\n") => helper(TextIO.input1 inStream, bmap, x+1, 1, flood, cat)
	  | SOME(#"W") => helper(TextIO.input1 inStream, S.insert(bmap, (x,y), (#"W", NONE: string option, 0, ~1, true, false, NONE: (int*int) option)), x, y+1, Queue.enqueue((x,y), flood), cat)
	  | SOME(#"A") => helper(TextIO.input1 inStream, S.insert(bmap, (x,y), (#"A", NONE: string option, ~1, 0, false, true, NONE: (int*int) option)), x, y+1, flood, Queue.enqueue ((x,y),cat))
	  | SOME(c) => helper(TextIO.input1 inStream, S.insert(bmap, (x,y), (c, NONE: string option, ~1, ~1, false, false, NONE: (int*int) option)), x, y+1, flood, cat)
    in
      helper (TextIO.input1 inStream, S.empty, 1, 1, Queue.empty, Queue.empty)
    end

fun printlist (l: char list) =
  if null l then print("\n")
  else (print(str(hd l)); printlist(tl l))

fun printlist' (l: (char * string option * int * int * bool * bool * (int * int) option) list) =
  if null l then print("\n")
  else (print(str(#1(hd l))); printlist'(tl l))

fun printflood (s: (char * string option * int * int * bool * bool * (int * int) option) S.map) =
  let
    fun print' (s: (char * string option * int * int * bool * bool * (int * int) option) S.map, (x:int, y:int)) =
	case S.find(s, (x,y)) of NONE => if y = 1 then print("")
					else (print("\n"); print'(s, (x+1, 1)))
			    | SOME(h) => (print(Int.toString(#3(h)) ^ " "); print' (s, (x, y + 1)))
  in 
     print' (s, (1, 1)) 
  end

fun find (s, ok) = 
  case S.find(s, ok) of SOME(c) => c
 
fun floodfill (bmap, flood) =
  if Queue.isEmpty(flood) then bmap
  else 
    let 
      val s = find(bmap, Queue.front(flood))
      fun down (bmap, flood) = case S.find(bmap, (#1(Queue.front(flood)) + 1,  #2(Queue.front(flood)))) of NONE => (bmap,flood)
                                  								| SOME((c, move, time, t, checked, visited,previous)) => if (c = #"X" orelse checked = true) then (bmap, flood)
                                               					     								   else
                                                                                                                                                     (S.insert(bmap,
                                                                                                                                                     (#1(Queue.front(flood)) + 1,
                                                                                                                                                     #2(Queue.front(flood))),
                                                                                                                                                     (c,
                                                                                                                                                     move,
                                                                                                                                                     #3(s)
                                                                                                                                                     +
                                                                                                                                                     1,
                                                                                                                                                     t,
                                                                                                                                                     true,
                                                                                                                                                     visited,
                                                                                                                                                     previous)),
                                                                                                                                                     Queue.enqueue((#1(Queue.front(flood))
                                                                                                                                                     +
                                                                                                                                                     1,
                                                                                                                                                     #2(Queue.front(flood))),
                                                                                                                                                     flood))
      fun left (bmap, flood) = case S.find(bmap, (#1(Queue.front(flood)), #2(Queue.front(flood)) - 1)) of NONE => (bmap,flood)
                                  								| SOME((c, move, time, t, checked, visited,previous)) => if (c = #"X" orelse checked = true) then (bmap, flood)
                                               					     								   else
                                                                                                                                                     (S.insert(bmap,
                                                                                                                                                     (#1(Queue.front(flood)),
                                                                                                                                                     #2(Queue.front(flood))-1),
                                                                                                                                                     (c,
                                                                                                                                                     move,
                                                                                                                                                     #3(s)
                                                                                                                                                     +
                                                                                                                                                     1,
                                                                                                                                                     t,
                                                                                                                                                     true,
                                                                                                                                                     visited,
                                                                                                                                                     previous)),
                                                                                                                                                     Queue.enqueue((#1(Queue.front(flood)),
                                                                                                                                                     #2(Queue.front(flood)) -1),
                                                                                                                                                     flood))
      fun right (bmap, flood) = case S.find(bmap, (#1(Queue.front(flood)), #2(Queue.front(flood)) + 1)) of NONE => (bmap,flood)
                                  								| SOME((c, move, time, t, checked, visited,previous)) => if (c = #"X" orelse checked = true) then (bmap, flood)
                                               					     								   else
                                                                                                                                                     (S.insert(bmap,
                                                                                                                                                     (#1(Queue.front(flood)),
                                                                                                                                                     #2(Queue.front(flood))+1), (c, move, #3(s) + 1, t, true, visited, previous)), Queue.enqueue((#1(Queue.front(flood)), #2(Queue.front(flood))+1), flood))
      fun up (bmap, flood) = case S.find(bmap, (#1(Queue.front(flood)) - 1, #2(Queue.front(flood)))) of NONE => (bmap,flood)
                                  								| SOME((c, move, time, t, checked, visited,previous)) => if (c = #"X" orelse checked = true) then (bmap, flood)
                                               					     								   else (S.insert(bmap, (#1(Queue.front(flood)) - 1, #2(Queue.front(flood))), (c, move, #3(s) + 1, t, true, visited, previous)), Queue.enqueue((#1(Queue.front(flood)) - 1, #2(Queue.front(flood))), flood))
    in
      floodfill(#1(up (right (left (down (bmap, flood))))), Queue.dequeue(#2(up(right(left(down(bmap, flood)))))))
    end

fun catpath (bmap, cat) = 
  let 
    fun catp (bmap, cat, maxtime, maxsquare) = 
       if Queue.isEmpty(cat) then (bmap, maxtime, maxsquare)
       else 
	 let 
	   val s = find(bmap, Queue.front(cat))
	   fun down (bmap, cat, maxtime, maxsquare) = case S.find(bmap, (#1(Queue.front(cat)) + 1,  #2(Queue.front(cat)))) 
							of NONE => (bmap,cat,maxtime,maxsquare)
							| SOME((c, move, time, t, checked, visited,previous)) => (if (c = #"X" orelse visited = true) then (bmap, cat, maxtime, maxsquare)
														else case time of ~1 => if (comp((#1(Queue.front(cat)) + 1,  #2(Queue.front(cat))), maxsquare) = LESS) then (S.insert(bmap, (#1(Queue.front(cat)) + 1, #2(Queue.front(cat))), (c, SOME("D"), time, t, checked, true, SOME(Queue.front(cat)))),
                            Queue.enqueue((#1(Queue.front(cat)) + 1, #2(Queue.front(cat))), cat), ~1, (#1(Queue.front(cat)) + 1, #2(Queue.front(cat))))
			else (S.insert(bmap, (#1(Queue.front(cat)) + 1, #2(Queue.front(cat))), (c, SOME("D"), time, t, checked, true, SOME(Queue.front(cat)))),
                            Queue.enqueue((#1(Queue.front(cat)) + 1, #2(Queue.front(cat))), cat), ~1, maxsquare)
															|_ => if (#4(s) + 1) < time then 
	(if (time - 1 > maxtime orelse (time - 1 = maxtime andalso (comp((#1(Queue.front(cat)) + 1,  #2(Queue.front(cat))), maxsquare) = LESS))) then
							(S.insert(bmap, (#1(Queue.front(cat)) + 1, #2(Queue.front(cat))), (c, SOME("D"), time, (#4(s) + 1), checked, true, SOME(Queue.front(cat)))),
                            Queue.enqueue((#1(Queue.front(cat)) + 1, #2(Queue.front(cat))), cat), time - 1, (#1(Queue.front(cat)) + 1, #2(Queue.front(cat))))
	else (S.insert(bmap, (#1(Queue.front(cat)) + 1, #2(Queue.front(cat))), (c, SOME("D"), time, (#4(s) + 1), checked, true, SOME(Queue.front(cat)))),
                            Queue.enqueue((#1(Queue.front(cat)) + 1, #2(Queue.front(cat))), cat), maxtime, maxsquare))
																else (bmap,cat,maxtime,maxsquare))
	   
	   fun left (bmap, cat, maxtime, maxsquare) = case S.find(bmap, (#1(Queue.front(cat)),  #2(Queue.front(cat)) - 1)) 
							of NONE => (bmap,cat,maxtime,maxsquare)
							| SOME((c, move, time, t, checked, visited,previous)) => (if (c = #"X" orelse visited = true) then (bmap, cat, maxtime, maxsquare)
														else case time of ~1 => if (comp((#1(Queue.front(cat)),  #2(Queue.front(cat)) - 1), maxsquare) = LESS) then (S.insert(bmap, (#1(Queue.front(cat)), #2(Queue.front(cat)) - 1), (c, SOME("L"), time, t, checked, true, SOME(Queue.front(cat)))),
                            Queue.enqueue((#1(Queue.front(cat)), #2(Queue.front(cat)) - 1), cat), ~1, (#1(Queue.front(cat)), #2(Queue.front(cat)) - 1))
			else (S.insert(bmap, (#1(Queue.front(cat)), #2(Queue.front(cat)) - 1), (c, SOME("L"), time, t, checked, true, SOME(Queue.front(cat)))),
                            Queue.enqueue((#1(Queue.front(cat)), #2(Queue.front(cat)) - 1), cat), ~1, maxsquare)
															|_ => if (#4(s) + 1) < time then 
	(if (time - 1 > maxtime orelse (time - 1 = maxtime andalso (comp((#1(Queue.front(cat)),  #2(Queue.front(cat)) - 1), maxsquare) = LESS))) then
							(S.insert(bmap, (#1(Queue.front(cat)), #2(Queue.front(cat)) - 1), (c, SOME("L"), time, (#4(s) + 1), checked, true, SOME(Queue.front(cat)))),
                            Queue.enqueue((#1(Queue.front(cat)), #2(Queue.front(cat)) - 1), cat), time - 1, (#1(Queue.front(cat)), #2(Queue.front(cat)) - 1))
	else (S.insert(bmap, (#1(Queue.front(cat)), #2(Queue.front(cat)) - 1), (c, SOME("L"), time, (#4(s) + 1), checked, true, SOME(Queue.front(cat)))),
                            Queue.enqueue((#1(Queue.front(cat)), #2(Queue.front(cat)) - 1), cat), maxtime, maxsquare))
																else (bmap,cat,maxtime,maxsquare))
	   
	   fun right (bmap, cat, maxtime, maxsquare) = case S.find(bmap, (#1(Queue.front(cat)),  #2(Queue.front(cat)) + 1)) 
							of NONE => (bmap,cat,maxtime,maxsquare)
							| SOME((c, move, time, t, checked, visited,previous)) => (if (c = #"X" orelse visited = true) then (bmap, cat, maxtime, maxsquare)
														else case time of ~1 => if (comp((#1(Queue.front(cat)),  #2(Queue.front(cat)) + 1), maxsquare) = LESS) then (S.insert(bmap, (#1(Queue.front(cat)), #2(Queue.front(cat)) + 1), (c, SOME("R"), time, t, checked, true, SOME(Queue.front(cat)))),
                            Queue.enqueue((#1(Queue.front(cat)), #2(Queue.front(cat)) + 1), cat), ~1, (#1(Queue.front(cat)), #2(Queue.front(cat)) + 1))
			else (S.insert(bmap, (#1(Queue.front(cat)), #2(Queue.front(cat)) + 1), (c, SOME("R"), time, t, checked, true, SOME(Queue.front(cat)))),
                            Queue.enqueue((#1(Queue.front(cat)), #2(Queue.front(cat)) + 1), cat), ~1, maxsquare)
															|_ => if (#4(s) + 1) < time then 
	(if (time - 1 > maxtime orelse (time - 1 = maxtime andalso (comp((#1(Queue.front(cat)),  #2(Queue.front(cat)) + 1), maxsquare) = LESS))) then
							(S.insert(bmap, (#1(Queue.front(cat)), #2(Queue.front(cat)) + 1), (c, SOME("R"), time, (#4(s) + 1), checked, true, SOME(Queue.front(cat)))),
                            Queue.enqueue((#1(Queue.front(cat)), #2(Queue.front(cat)) + 1), cat), time - 1, (#1(Queue.front(cat)), #2(Queue.front(cat)) + 1))
	else (S.insert(bmap, (#1(Queue.front(cat)), #2(Queue.front(cat)) + 1), (c, SOME("R"), time, (#4(s) + 1), checked, true, SOME(Queue.front(cat)))),
                            Queue.enqueue((#1(Queue.front(cat)), #2(Queue.front(cat)) + 1), cat), maxtime, maxsquare))
																else (bmap,cat,maxtime,maxsquare))

	   fun up (bmap, cat, maxtime, maxsquare) = case S.find(bmap, (#1(Queue.front(cat)) - 1,  #2(Queue.front(cat)))) 
							of NONE => (bmap,cat,maxtime,maxsquare)
							| SOME((c, move, time, t, checked, visited,previous)) => (if (c = #"X" orelse visited = true) then (bmap, cat, maxtime, maxsquare)
														else case time of ~1 => if (comp((#1(Queue.front(cat)) - 1,  #2(Queue.front(cat))), maxsquare) = LESS) then (S.insert(bmap, (#1(Queue.front(cat)) - 1, #2(Queue.front(cat))), (c, SOME("U"), time, t, checked, true, SOME(Queue.front(cat)))),
                            Queue.enqueue((#1(Queue.front(cat)) - 1, #2(Queue.front(cat))), cat), ~1, (#1(Queue.front(cat)) - 1, #2(Queue.front(cat))))
			else (S.insert(bmap, (#1(Queue.front(cat)) - 1, #2(Queue.front(cat))), (c, SOME("U"), time, t, checked, true, SOME(Queue.front(cat)))),
                            Queue.enqueue((#1(Queue.front(cat)) - 1, #2(Queue.front(cat))), cat), ~1, maxsquare)
															|_ => if (#4(s) + 1) < time then 
	(if (time - 1 > maxtime orelse (time - 1 = maxtime andalso (comp((#1(Queue.front(cat)) - 1,  #2(Queue.front(cat))), maxsquare) = LESS))) then
							(S.insert(bmap, (#1(Queue.front(cat)) - 1, #2(Queue.front(cat))), (c, SOME("U"), time, (#4(s) + 1), checked, true, SOME(Queue.front(cat)))),
                            Queue.enqueue((#1(Queue.front(cat)) - 1, #2(Queue.front(cat))), cat), time - 1, (#1(Queue.front(cat)) - 1, #2(Queue.front(cat))))
	else (S.insert(bmap, (#1(Queue.front(cat)) - 1, #2(Queue.front(cat))), (c, SOME("U"), time, (#4(s) + 1), checked, true, SOME(Queue.front(cat)))),
                            Queue.enqueue((#1(Queue.front(cat)) - 1, #2(Queue.front(cat))), cat), maxtime, maxsquare))
																else (bmap,cat,maxtime,maxsquare))


	 in
	   catp (#1(up (right (left (down (bmap, cat, maxtime, maxsquare))))), Queue.dequeue(#2(up(right(left(down(bmap, cat, maxtime, maxsquare)))))), #3(up (right (left (down (bmap, cat, maxtime, maxsquare))))), #4(up (right (left (down (bmap, cat, maxtime, maxsquare))))))
	 end
  in
    catp (bmap, cat, ~1, Queue.front(cat))
  end

in

fun savethecat filename =
  let 
     val (bmap, flood, cat) = parse filename 
  in
     let
	val (bmap, maxtime, maxsquare) = catpath (floodfill (bmap, flood), cat)
	fun path (bmap, maxsquare) = 
	   let 
	      fun route (bmap, square, w) =
		case S.find(bmap, square) of NONE => w
			| SOME ((c, move, time, t, checked, visited,previous)) => case move of NONE => w
											| SOME (m) => route(bmap, Option.valOf previous, m ^ w)
	   in
	      route (bmap, maxsquare, "")
           end
     in
	(case maxtime of ~1 => print ("infinity\n")
			| _ => print (Int.toString (maxtime) ^ "\n");
         if (Queue.front(cat) = maxsquare) then print ("stay\n")
         else print (path(bmap, maxsquare) ^ "\n"))
     end
  end

end
