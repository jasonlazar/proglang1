(* Για το διάβασμα του αρχείου χρησιμοποίηθηκε βοηθητικός κώδικας από http://courses.softlab.ntua.gr/pl1/2013a/Exercises/countries.sml*)

local

structure S = BinaryMapFn(struct
	type ord_key = int
	val compare = Int.compare
  end)

fun parse file =
  let
    val inStream = TextIO.openIn file
    fun readInt input = 
	    Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
    val n = readInt inStream
    val k = readInt inStream
    val _ = TextIO.inputLine inStream
    fun readInts (0, bmap) = (TextIO.closeIn inStream; bmap) 
	  | readInts (i, bmap) = readInts ((i - 1), S.insert(bmap, i, (readInt inStream)))
  in
    (n, k, readInts(n, S.empty))
  end

fun zeromap (0, bmap) = bmap
	| zeromap (k, bmap) = zeromap (k-1, S.insert(bmap, k, 0))

fun findm(n, k, bmap, count) =
  let
	fun findmax (n, k, first, last, length, seen, bmap, count) = 
		if length = k then k
		else (if seen = k then 
		  (if (last - first + 1 < length) then case (Option.valOf(S.find(count, Option.valOf(S.find(bmap, first)))) - 1) of 0 => findmax (n, k, first+1, last, last-first +1, k-1, bmap, S.insert(count, Option.valOf(S.find(bmap, first)), (Option.valOf(S.find(count, Option.valOf(S.find(bmap, first)))) - 1)))
															|_ => findmax (n, k, first+1, last, last - first + 1, k, bmap, S.insert(count, Option.valOf(S.find(bmap, first)), (Option.valOf(S.find(count, Option.valOf(S.find(bmap, first)))) - 1)))
		   else case (Option.valOf(S.find(count, Option.valOf(S.find(bmap, first)))) - 1) of 0 => findmax (n, k, first+1, last, length, k-1, bmap, S.insert(count, Option.valOf(S.find(bmap, first)), (Option.valOf(S.find(count, Option.valOf(S.find(bmap, first)))) - 1)))
												|_ => findmax (n, k, first+1, last, length, k, bmap, S.insert(count, Option.valOf(S.find(bmap, first)), (Option.valOf(S.find(count, Option.valOf(S.find(bmap, first)))) - 1))))
			  else (if last = n then length
				else   case (Option.valOf(S.find(count, Option.valOf(S.find(bmap, last + 1))))) of 0 => findmax (n, k, first, last+1, length, seen+1, bmap, S.insert(count, Option.valOf(S.find(bmap, last +1)), (Option.valOf(S.find(count, Option.valOf(S.find(bmap, last+1)))) + 1)))
														|_ => findmax (n, k, first, last+1, length, seen, bmap, S.insert(count, Option.valOf(S.find(bmap, last +1)), (Option.valOf(S.find(count, Option.valOf(S.find(bmap, last+1)))) + 1)))))
  in
	findmax(n, k, 1, 0, n+1, 0, bmap, count)
  end

in

fun colors filename =
  let 
     val (n, k, bmap) = parse filename
  in
     let 
	val max = findm(n, k, bmap, (zeromap(k, S.empty)))
     in
	if max = (n+1) then print ("0\n")
	else print (Int.toString(max) ^ "\n")
     end
  end

end
