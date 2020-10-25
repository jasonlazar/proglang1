import java.io.*;
import java.util.*;
import java.awt.Point;



public class SaveTheCat{
	private static int N = 0;
	private static int M = 0;
	public static void main(String args[]){
		try{
			BufferedReader instream = new BufferedReader(new FileReader(args[0]));
			Cell[][] map = new Cell[1000][1000];
			int c = instream.read();
			int j = 0;
			Queue<Cell> flood = new ArrayDeque<Cell>();
			Queue<Cell> cat = new ArrayDeque<Cell>();
			while(c!=-1){
				if ((char) c == '\n'){
					N++;
					M = j;
					j = -1;
				}
				else if ((char) c == 'W') {
					map[N][j] = new Cell('W', 0, -1, N, j, true, false);
					flood.add(map[N][j]);
				}
				else if ((char) c == 'A') {
					map[N][j] = new Cell('A', -1, 0, N, j, false, true);
					cat.add(map[N][j]);
				}
				else map[N][j] = new Cell((char) c, -1, -1, N, j, false, false);
				j++;
				c = instream.read();
			}
			Flood FLOOD = new Flood(flood, N, M);
			Cat CAT = new Cat(cat, N, M);
			instream.close();
			FLOOD.floodfill(map);
			CAT.catpath(map);
		}
		catch (Exception e){
			System.err.println("Exception occured");
			e.printStackTrace();
		}
	}
}
