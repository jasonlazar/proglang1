import java.util.*;

public class Flood{

	private Queue<Cell> flood;
	private int N, M;

	public Flood(Queue<Cell> f, int N, int M){
		flood = f;
		this.N = N;
		this.M = M;
	}

	public void floodfill(Cell[][] map){
		Cell first = flood.poll();
		while (first != null){
			if (first.getX() - 1 >= 0){
				if (map[first.getX() - 1][first.getY()].getc() != 'X' && map[first.getX()-1][first.getY()].getChecked() == false){
					map[first.getX() - 1][first.getY()].setTime(first.getTime() + 1);
					map[first.getX() - 1][first.getY()].setChecked();
					flood.add(map[first.getX() - 1][first.getY()]);
				}
			}
			if (first.getX() + 1 < N){
				if (map[first.getX() + 1][first.getY()].getc() != 'X' && map[first.getX()+1][first.getY()].getChecked() == false){
					map[first.getX() + 1][first.getY()].setTime(first.getTime() + 1);
					map[first.getX() + 1][first.getY()].setChecked();
					flood.add(map[first.getX() + 1][first.getY()]);
				}
			}
			if (first.getY() + 1 < M){
				if (map[first.getX()][first.getY() + 1].getc() != 'X' && map[first.getX()][first.getY()+1].getChecked() == false){
					map[first.getX()][first.getY()+1].setTime(first.getTime() + 1);
					map[first.getX()][first.getY()+1].setChecked();
					flood.add(map[first.getX()][first.getY()+1]);
				}
			}
			if (first.getY() - 1 >= 0){
				if (map[first.getX()][first.getY() - 1].getc() != 'X' && map[first.getX()][first.getY()-1].getChecked() == false){
					map[first.getX()][first.getY()-1].setTime(first.getTime() + 1);
					map[first.getX()][first.getY()-1].setChecked();
					flood.add(map[first.getX()][first.getY()-1]);
				}
			}
			first = flood.poll();
		}
	}
}
