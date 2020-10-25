//Ο ακόλουθος κώδικας είναι επηρεασμένος από τον κώδικα του δεύτερου εργαστηρίου σε Java
import java.util.*;

public class ZState implements Comparable{
	public List<Integer> sofar;
	private String path;
	private int Lout, Rout;

	public ZState(List<Integer> s, String p, int Lout, int Rout){
		sofar = new ArrayList<>(s);
		path = new String(p);
		this.Lout = Lout;
		this.Rout = Rout;
	} 

	public boolean isFinal(){
		for (int s : sofar){
			if (s< Lout || s > Rout) return false;
		}
		return true;
	}
		
	public boolean isBad(){
		for (int s : sofar){
			if (s >= 1000000 || s < 0) return true;
		}
		return false;
	}

	public Collection<ZState> next(){
		Collection<ZState> states = new ArrayList<>();
		List<Integer> hlist = new ArrayList<>();
		for (int h : sofar){
			hlist.add(h/2);
		}
		ZState hnext = new ZState(hlist, path + 'h', Lout, Rout);
		states.add(hnext);
		List<Integer> tlist = new ArrayList<>();
		for (int t : sofar) tlist.add(3*t + 1);
		ZState tnext = new ZState(tlist, path + 't', Lout, Rout);
		states.add(tnext);
		return states;
	}

	@Override
	public boolean equals(Object o){
		if (this == o) return true;
		if (o == null || getClass() != o.getClass()) return false;
		ZState other = (ZState) o;
		Iterator<Integer> first = sofar.iterator();
		Iterator<Integer> second = other.sofar.iterator();
		while(first.hasNext() && second.hasNext()){
			if (!first.next().equals(second.next())) return false;
		}
		if (first.hasNext() || second.hasNext()) return false;
		return true;
	}

	@Override
	public int compareTo(Object o){
		ZState z = (ZState) o;
		int size = sofar.size();
		for (int i = 0; i<size; i++) {
			if (sofar.get(i) < z.sofar.get(i)) return -1;
			else if (sofar.get(i) > z.sofar.get(i)) return 1;
		}
		return 0;
	}

	@Override
	public String toString(){
		if (path.equals("")) return "EMPTY";
		else return path;
	}
}
