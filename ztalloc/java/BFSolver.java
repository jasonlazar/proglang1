//Ο κώδικας είναι επηρεασμένος από τον κώδικα του δεύτερου εργαστηρίου σε Java
import java.util.*;

public class BFSolver {
	public ZState solve (ZState initial) {
		Set<ZState> seen = new TreeSet<>();
		Queue<ZState> remaining = new ArrayDeque<>();
		remaining.add(initial);
		seen.add(initial);
		while (!remaining.isEmpty()) {
			ZState s = remaining.remove();
			if (s.isFinal()) return s;
			for (ZState n : s.next())
				if (!seen.contains(n) && !n.isBad()){
					remaining.add(n);
					seen.add(n);
				}
		}
		return null;
	}
}
