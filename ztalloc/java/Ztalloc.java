import java.io.*;
import java.util.*;

public class Ztalloc{
	
	public static void main(String[] args){
		try{
			BufferedReader instream = new BufferedReader(new FileReader(args[0]));
			int Q = Integer.parseInt(instream.readLine());
			for (int i = 0; i < Q; i++){
				String[] line = instream.readLine().split(" ");
				int Lin = Integer.parseInt(line[0]);
				int Rin = Integer.parseInt(line[1]);
				int Lout = Integer.parseInt(line[2]);
				int Rout = Integer.parseInt(line[3]);
				List<Integer> range = new ArrayList<>();
				range.add(Lin);
				if (Lin!=Rin) range.add(Rin);
				ZState initial = new ZState(range, "", Lout, Rout);
				BFSolver solver = new BFSolver();
				ZState result = solver.solve(initial);
				if (result == null) System.out.println("IMPOSSIBLE");
				else System.out.println(result);
			}
			instream.close();
		}
		catch (Exception e){
			e.printStackTrace();
		}
	}
}
