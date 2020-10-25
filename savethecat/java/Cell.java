import java.awt.Point;

public class Cell{
	private char c, move;
	private int time, t, x, y;
	private boolean checked, visited;
	private Cell previous = null;

	public Cell(char c, int time, int t, int x, int y, boolean checked, boolean visited){
		this.c = c;
		this.time = time;
		this.t = t;
		this.x = x;
		this.y = y;
		this.checked = checked;
		this.visited = visited;
	}

	public char getc(){
		return c;
	}

	public int getX(){
		return x;
	}

	public int getY(){
		return y;
	}

	public char getMove(){
		return move;
	}

	public int getTime(){
		return time;
	}

	public int gett(){
		return t;
	}

	public boolean getChecked(){
		return checked;
	}

	public boolean getVisited(){
		return visited;
	}
	
	public Cell getPrevious(){
		return previous;
	}

	public void setMove(char m){
		move = m;
	}

	public void setTime(int t){
		time = t;
	}

	public void sett(int time){
		t = time;
	}

	public void setChecked(){
		checked = true;
	}

	public void setVisited(){
		visited = true;
	}

	public void setPrevious(Cell prev){
		previous = prev;
	}
}
