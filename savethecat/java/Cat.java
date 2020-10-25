import java.util.*;

public class Cat{
	
	private Queue<Cell> cat;
	private int N, M;

	public Cat(Queue<Cell> c, int N, int M){
		cat = c;
		this.N = N;
		this.M = M;
	}

	public void catpath(Cell[][] map){
		int maxtime = 0;
		String path = new String("");
		Cell first = cat.poll();
		Cell maxcell = first;
		if (maxcell.getTime() != -1){
			while (first != null){
				if (first.getX() + 1 < N){
                                	if (map[first.getX() + 1][first.getY()].getc() != 'X' && map[first.getX()+1][first.getY()].getVisited() == false && first.gett()+1 < map[first.getX()+1][first.getY()].getTime()){
                                        	map[first.getX() + 1][first.getY()].sett(first.gett() + 1);
                                        	map[first.getX() + 1][first.getY()].setVisited();
						map[first.getX() + 1][first.getY()].setMove('D');
						map[first.getX() + 1][first.getY()].setPrevious(first);
						if (map[first.getX() + 1][first.getY()].getTime() - 1 > maxtime) {
							maxtime = map[first.getX() + 1][first.getY()].getTime() - 1;
							maxcell = map[first.getX() + 1][first.getY()];
						}
						else if ((map[first.getX() + 1][first.getY()].getTime() - 1 == maxtime) && (first.getX()+1 < maxcell.getX())) maxcell = map[first.getX()+1][first.getY()];
						else if ((map[first.getX() + 1][first.getY()].getTime() - 1 == maxtime) && (first.getX()+1 == maxcell.getX()) && (first.getY()<maxcell.getY())) maxcell = map[first.getX()+1][first.getY()];
                                        	cat.add(map[first.getX() + 1][first.getY()]);
                                	}
                        	}	
				if (first.getY() - 1 >= 0){
                                        if (map[first.getX()][first.getY()-1].getc() != 'X' && map[first.getX()][first.getY()-1].getVisited() == false && first.gett()+1 < map[first.getX()][first.getY()-1].getTime()){
                                                map[first.getX()][first.getY()-1].sett(first.gett() + 1);
                                                map[first.getX()][first.getY()-1].setVisited();
                                                map[first.getX()][first.getY()-1].setMove('L');
                                                map[first.getX()][first.getY()-1].setPrevious(first);
                                                if (map[first.getX()][first.getY()-1].getTime() - 1 > maxtime) {
                                                        maxtime = map[first.getX()][first.getY()-1].getTime() - 1;
                                                        maxcell = map[first.getX()][first.getY()-1];
                                                }
                                                else if ((map[first.getX()][first.getY()-1].getTime() - 1 == maxtime) && (first.getX() < maxcell.getX())) maxcell = map[first.getX()][first.getY()-1];
                                                else if ((map[first.getX()][first.getY()-1].getTime() - 1 == maxtime) && (first.getX() == maxcell.getX()) && (first.getY()-1<maxcell.getY())) maxcell = map[first.getX()][first.getY()-1];
                                                cat.add(map[first.getX()][first.getY()-1]);
                                        }
                                }
				if (first.getY() + 1 < M){
                                        if (map[first.getX()][first.getY()+1].getc() != 'X' && map[first.getX()][first.getY()+1].getVisited() == false && first.gett()+1 < map[first.getX()][first.getY()+1].getTime()){
                                                map[first.getX()][first.getY()+1].sett(first.gett() + 1);
                                                map[first.getX()][first.getY()+1].setVisited();
                                                map[first.getX()][first.getY()+1].setMove('R');
                                                map[first.getX()][first.getY()+1].setPrevious(first);
                                                if (map[first.getX()][first.getY()+1].getTime() - 1 > maxtime) {
                                                        maxtime = map[first.getX()][first.getY()+1].getTime() - 1;
                                                        maxcell = map[first.getX()][first.getY()+1];
                                                }
                                                else if ((map[first.getX()][first.getY()+1].getTime() - 1 == maxtime) && (first.getX() < maxcell.getX())) maxcell = map[first.getX()][first.getY()+1];
                                                else if ((map[first.getX()][first.getY()+1].getTime() - 1 == maxtime) && (first.getX() == maxcell.getX()) && (first.getY()+1<maxcell.getY())) maxcell = map[first.getX()][first.getY()+1];
                                                cat.add(map[first.getX()][first.getY()+1]);
                                        }
                                }
				if (first.getX() - 1 >= 0){
                                	if (map[first.getX() - 1][first.getY()].getc() != 'X' && map[first.getX()-1][first.getY()].getVisited() == false && first.gett()+1 < map[first.getX()-1][first.getY()].getTime()){
                                        	map[first.getX() - 1][first.getY()].sett(first.gett() + 1);
                                        	map[first.getX() - 1][first.getY()].setVisited();
						map[first.getX() - 1][first.getY()].setMove('U');
						map[first.getX() - 1][first.getY()].setPrevious(first);
						if (map[first.getX() - 1][first.getY()].getTime() - 1 > maxtime) {
							maxtime = map[first.getX() - 1][first.getY()].getTime() - 1;
							maxcell = map[first.getX() - 1][first.getY()];
						}
						else if ((map[first.getX() - 1][first.getY()].getTime() - 1 == maxtime) && (first.getX()-1 < maxcell.getX())) maxcell = map[first.getX()-1][first.getY()];
						else if ((map[first.getX() - 1][first.getY()].getTime() - 1 == maxtime) && (first.getX()-1 == maxcell.getX()) && (first.getY()<maxcell.getY())) maxcell = map[first.getX()-1][first.getY()];
                                        	cat.add(map[first.getX() - 1][first.getY()]);
                                	}
                        	}
				first = cat.poll();
			}
			System.out.println(maxtime);
			Cell temp = maxcell;
			while (temp.getPrevious() != null) {
				path = temp.getMove() + path;
				temp = temp.getPrevious();
			}
			if (path.equals("")) System.out.println("stay");
			else System.out.println(path);
		}
		else{
			while (first != null){
				if (first.getX() + 1 < N){
                                        if (map[first.getX() + 1][first.getY()].getc() != 'X' && map[first.getX()+1][first.getY()].getVisited() == false){
                                                map[first.getX() + 1][first.getY()].setVisited();
                                                map[first.getX() + 1][first.getY()].setMove('D');
                                                map[first.getX() + 1][first.getY()].setPrevious(first);
                                                if (first.getX()+1 < maxcell.getX()) maxcell = map[first.getX()+1][first.getY()];
                                                else if ((first.getX()+1 == maxcell.getX()) && (first.getY()<maxcell.getY())) maxcell = map[first.getX()+1][first.getY()];
                                                cat.add(map[first.getX() + 1][first.getY()]);
                                        }
                                }
				if (first.getY() - 1 >= 0){
                                        if (map[first.getX()][first.getY()-1].getc() != 'X' && map[first.getX()][first.getY()-1].getVisited() == false){
                                                map[first.getX()][first.getY()-1].setVisited();
                                                map[first.getX()][first.getY()-1].setMove('L');
                                                map[first.getX()][first.getY()-1].setPrevious(first);
                                                if (first.getX() < maxcell.getX()) maxcell = map[first.getX()][first.getY()-1];
                                                else if ((first.getX() == maxcell.getX()) && (first.getY()-1<maxcell.getY())) maxcell = map[first.getX()][first.getY()-1];
                                                cat.add(map[first.getX()][first.getY()-1]);
                                        }
                                }
				if (first.getY() + 1 < M){
                                        if (map[first.getX()][first.getY()+1].getc() != 'X' && map[first.getX()][first.getY()+1].getVisited() == false){
                                                map[first.getX()][first.getY()+1].setVisited();
                                                map[first.getX()][first.getY()+1].setMove('R');
                                                map[first.getX()][first.getY()+1].setPrevious(first);
                                                if (first.getX() < maxcell.getX()) maxcell = map[first.getX()][first.getY()+1];
                                                else if ((first.getX() == maxcell.getX()) && (first.getY()+1<maxcell.getY())) maxcell = map[first.getX()][first.getY()+1];
                                                cat.add(map[first.getX()][first.getY()+1]);
                                        }
                                }
				if (first.getX() - 1 >= 0){
                                	if (map[first.getX() - 1][first.getY()].getc() != 'X' && map[first.getX()-1][first.getY()].getVisited() == false){
                                        	map[first.getX() - 1][first.getY()].setVisited();
						map[first.getX() - 1][first.getY()].setMove('U');
						map[first.getX() - 1][first.getY()].setPrevious(first);
						if (first.getX()-1 < maxcell.getX()) maxcell = map[first.getX()-1][first.getY()];
						else if ((first.getX()-1 == maxcell.getX()) && (first.getY()<maxcell.getY())) maxcell = map[first.getX()-1][first.getY()];
                                        	cat.add(map[first.getX() - 1][first.getY()]);
                                	}
                        	}
				first = cat.poll();
			}
			System.out.println("infinity");
			Cell temp = maxcell;
			while (temp.getPrevious() != null){
				path = temp.getMove() + path;
				temp = temp.getPrevious();
			}
			if (path.equals("")) System.out.println("stay");
			else System.out.println(path);
		}
	}

	private class Flood{

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
}
