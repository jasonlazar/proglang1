#include<iostream>
#include<iomanip>
#include<fstream>
#include<string>

using namespace std;

struct square{
	char c, move;
	int time=-1, t=-1, pos[2];
	bool checked = false, visited = false;
	square *previous = nullptr;
} map[1000][1000];

struct node {
	square *info;
	node *next;
};

class queue{
	public:
		queue(){
			first = nullptr;
			last = nullptr;
		}
		void push(square &s){
			node *temp = new node;
			temp->info = &s;
			temp->next = nullptr;
			if (first == nullptr) first = temp;
			else last->next = temp;
			last = temp;
		}
		square *front(){
			if (first != NULL) return first->info;
			else return NULL;
		}
		void pop(){
			node *temp = new node;
			temp = first;
			first = first->next;
			delete temp;
		}
		bool empty(){
			return first==nullptr;
		}
		void floodfill(int N, int M){
		   	while(!this->empty()){
				if (first->info->pos[0] -1 >= 0){
					if (map[first->info->pos[0]-1][first->info->pos[1]].c != 'X' && map[first->info->pos[0]-1][first->info->pos[1]].checked == false){
						map[first->info->pos[0]-1][first->info->pos[1]].time = first->info->time + 1;
						map[first->info->pos[0]-1][first->info->pos[1]].checked = true;
						this->push(map[first->info->pos[0]-1][first->info->pos[1]]);
					}
				}
				if (first->info->pos[0] +1 < N){
					if (map[first->info->pos[0]+1][first->info->pos[1]].c != 'X' && map[first->info->pos[0]+1][first->info->pos[1]].checked == false){
						map[first->info->pos[0]+1][first->info->pos[1]].time = first->info->time + 1;
						map[first->info->pos[0]+1][first->info->pos[1]].checked = true; 
						this->push(map[first->info->pos[0]+1][first->info->pos[1]]);
					}
				}
				if (first->info->pos[1] - 1 >=0){
					if (map[first->info->pos[0]][first->info->pos[1]-1].c != 'X' && map[first->info->pos[0]][first->info->pos[1]-1].checked == false){
						map[first->info->pos[0]][first->info->pos[1]-1].time = first->info->time + 1; 
						map[first->info->pos[0]][first->info->pos[1]-1].checked = true;
						this->push(map[first->info->pos[0]][first->info->pos[1]-1]);
					}
				}
				if (first->info->pos[1] + 1 < M){
					if (map[first->info->pos[0]][first->info->pos[1]+1].c != 'X' && map[first->info->pos[0]][first->info->pos[1]+1].checked == false){
						map[first->info->pos[0]][first->info->pos[1]+1].time = first->info->time + 1; 
						map[first->info->pos[0]][first->info->pos[1]+1].checked = true;
						this->push(map[first->info->pos[0]][first->info->pos[1]+1]);
					}
				}
				this->pop();
			}	
		}
		void catpath(int N, int M){
			int maxtime = 0;
			string path = "";
			square *maxsquare = new square;
			maxsquare = first->info;
			if (maxsquare->time != -1){
				while(! this->empty()){
					if (first->info->pos[0] + 1 < N){
						if (map[first->info->pos[0]+1][first->info->pos[1]].c != 'X' && map[first->info->pos[0]+1][first->info->pos[1]].visited == false && first->info->t+1 < map[first->info->pos[0]+1][first->info->pos[1]].time){
							map[first->info->pos[0]+1][first->info->pos[1]].t = first->info->t + 1;
							map[first->info->pos[0]+1][first->info->pos[1]].visited = true; 
							map[first->info->pos[0]+1][first->info->pos[1]].move = 'D';
							map[first->info->pos[0]+1][first->info->pos[1]].previous = new square;
							map[first->info->pos[0]+1][first->info->pos[1]].previous = &map[first->info->pos[0]][first->info->pos[1]];
							if (map[first->info->pos[0]+1][first->info->pos[1]].time - 1 > maxtime) {
								maxtime = map[first->info->pos[0]+1][first->info->pos[1]].time -1;
								maxsquare = &map[first->info->pos[0]+1][first->info->pos[1]];
							}
							else if ((map[first->info->pos[0]+1][first->info->pos[1]].time - 1 == maxtime) && (first->info->pos[0]+1 < maxsquare->pos[0])) maxsquare = &map[first->info->pos[0]+1][first->info->pos[1]];
							else if ((map[first->info->pos[0]+1][first->info->pos[1]].time - 1 == maxtime) && (first->info->pos[0]+1 == maxsquare->pos[0]) && (first->info->pos[1] < maxsquare->pos[1])) maxsquare = &map[first->info->pos[0]+1][first->info->pos[1]];
							this->push(map[first->info->pos[0]+1][first->info->pos[1]]);
						}
					}
					if (first->info->pos[1] - 1 >= 0){
						if (map[first->info->pos[0]][first->info->pos[1]-1].c != 'X' && map[first->info->pos[0]][first->info->pos[1]-1].visited == false && first->info->t+1 < map[first->info->pos[0]][first->info->pos[1]-1].time){
							map[first->info->pos[0]][first->info->pos[1]-1].t = first->info->t + 1; 
							map[first->info->pos[0]][first->info->pos[1]-1].visited = true;
							map[first->info->pos[0]][first->info->pos[1]-1].move = 'L';
							map[first->info->pos[0]][first->info->pos[1]-1].previous = new square;
							map[first->info->pos[0]][first->info->pos[1]-1].previous = &map[first->info->pos[0]][first->info->pos[1]];
							if (map[first->info->pos[0]][first->info->pos[1]-1].time - 1 > maxtime) {
								maxtime = map[first->info->pos[0]][first->info->pos[1]-1].time -1;
								maxsquare = &map[first->info->pos[0]][first->info->pos[1]-1];
							}
							else if ((map[first->info->pos[0]][first->info->pos[1]-1].time - 1 == maxtime) && (first->info->pos[0] < maxsquare->pos[0])) maxsquare = &map[first->info->pos[0]][first->info->pos[1]-1];
							else if ((map[first->info->pos[0]][first->info->pos[1]-1].time - 1 == maxtime) && (first->info->pos[0] == maxsquare->pos[0]) && (first->info->pos[1]-1 < maxsquare->pos[1])) maxsquare = &map[first->info->pos[0]][first->info->pos[1]-1];
							this->push(map[first->info->pos[0]][first->info->pos[1]-1]);
						}
					}
					if (first->info->pos[1] + 1 < M){
						if (map[first->info->pos[0]][first->info->pos[1]+1].c != 'X' && map[first->info->pos[0]][first->info->pos[1]+1].visited == false && first->info->t+1 < map[first->info->pos[0]][first->info->pos[1]+1].time){
							map[first->info->pos[0]][first->info->pos[1]+1].t = first->info->t + 1; 
							map[first->info->pos[0]][first->info->pos[1]+1].visited = true;
							map[first->info->pos[0]][first->info->pos[1]+1].move = 'R';
							map[first->info->pos[0]][first->info->pos[1]+1].previous = new square;
							map[first->info->pos[0]][first->info->pos[1]+1].previous = &map[first->info->pos[0]][first->info->pos[1]];
							if (map[first->info->pos[0]][first->info->pos[1]+1].time - 1 > maxtime) {
								maxtime = map[first->info->pos[0]][first->info->pos[1]+1].time -1;
								maxsquare = &map[first->info->pos[0]][first->info->pos[1]+1];
							}
							else if ((map[first->info->pos[0]][first->info->pos[1]+1].time - 1 == maxtime) && (first->info->pos[0] < maxsquare->pos[0])) maxsquare = &map[first->info->pos[0]][first->info->pos[1]+1];
							else if ((map[first->info->pos[0]][first->info->pos[1]+1].time - 1 == maxtime) && (first->info->pos[0] == maxsquare->pos[0]) && (first->info->pos[1]+1 < maxsquare->pos[1])) maxsquare = &map[first->info->pos[0]][first->info->pos[1]+1];
							this->push(map[first->info->pos[0]][first->info->pos[1]+1]);
						}
					}
					if (first->info->pos[0] - 1 >= 0){
						if (map[first->info->pos[0]-1][first->info->pos[1]].c != 'X' && map[first->info->pos[0]-1][first->info->pos[1]].visited == false && first->info->t+1 < map[first->info->pos[0]-1][first->info->pos[1]].time){
							map[first->info->pos[0]-1][first->info->pos[1]].t = first->info->t + 1;
							map[first->info->pos[0]-1][first->info->pos[1]].visited = true;
							map[first->info->pos[0]-1][first->info->pos[1]].move = 'U';
							map[first->info->pos[0]-1][first->info->pos[1]].previous = new square;
							map[first->info->pos[0]-1][first->info->pos[1]].previous = &map[first->info->pos[0]][first->info->pos[1]];
							if (map[first->info->pos[0]-1][first->info->pos[1]].time - 1 > maxtime) {
								maxtime = map[first->info->pos[0]-1][first->info->pos[1]].time -1;
								maxsquare = &map[first->info->pos[0]-1][first->info->pos[1]];
							}
							else if ((map[first->info->pos[0]-1][first->info->pos[1]].time - 1 == maxtime) && (first->info->pos[0]-1 < maxsquare->pos[0])) maxsquare = &map[first->info->pos[0]-1][first->info->pos[1]];
							else if ((map[first->info->pos[0]-1][first->info->pos[1]].time - 1 == maxtime) && (first->info->pos[0]-1 == maxsquare->pos[0]) && (first->info->pos[1] < maxsquare->pos[1])) maxsquare = &map[first->info->pos[0]-1][first->info->pos[1]];
							this->push(map[first->info->pos[0]-1][first->info->pos[1]]);
						}
					}
					this->pop();
				}
				cout << maxtime << endl;
				square *temp = new square;
				temp = maxsquare;
				while (temp->previous != nullptr) {
					path = temp->move + path;
					temp = temp->previous;
				}
				if ( path == "") cout << "stay\n";
				else cout << path << endl;
			}
			else{
				while(! this->empty()){
					if (first->info->pos[0] + 1 < N){
						if (map[first->info->pos[0]+1][first->info->pos[1]].c != 'X' && map[first->info->pos[0]+1][first->info->pos[1]].visited == false){
							map[first->info->pos[0]+1][first->info->pos[1]].visited = true; 
							map[first->info->pos[0]+1][first->info->pos[1]].move = 'D';
							map[first->info->pos[0]+1][first->info->pos[1]].previous = new square;
							map[first->info->pos[0]+1][first->info->pos[1]].previous = &map[first->info->pos[0]][first->info->pos[1]];
							if (first->info->pos[0]+1 < maxsquare->pos[0]) maxsquare = &map[first->info->pos[0]+1][first->info->pos[1]];
							else if ((first->info->pos[0]+1 == maxsquare->pos[0]) && (first->info->pos[1] < maxsquare->pos[1])) maxsquare = &map[first->info->pos[0]+1][first->info->pos[1]];
							this->push(map[first->info->pos[0]+1][first->info->pos[1]]);
						}
					}
					if (first->info->pos[1] - 1 >= 0){
						if (map[first->info->pos[0]][first->info->pos[1]-1].c != 'X' && map[first->info->pos[0]][first->info->pos[1]-1].visited == false){
							map[first->info->pos[0]][first->info->pos[1]-1].visited = true;
							map[first->info->pos[0]][first->info->pos[1]-1].move = 'L';
							map[first->info->pos[0]][first->info->pos[1]-1].previous = new square;
							map[first->info->pos[0]][first->info->pos[1]-1].previous = &map[first->info->pos[0]][first->info->pos[1]];
							if (first->info->pos[0] < maxsquare->pos[0]) maxsquare = &map[first->info->pos[0]][first->info->pos[1]-1];
							else if ((first->info->pos[0] == maxsquare->pos[0]) && (first->info->pos[1]-1 < maxsquare->pos[1])) maxsquare = &map[first->info->pos[0]][first->info->pos[1]-1];
							this->push(map[first->info->pos[0]][first->info->pos[1]-1]);
						}
					}
					if (first->info->pos[1] + 1 < M){
						if (map[first->info->pos[0]][first->info->pos[1]+1].c != 'X' && map[first->info->pos[0]][first->info->pos[1]+1].visited == false){
							map[first->info->pos[0]][first->info->pos[1]+1].visited = true;
							map[first->info->pos[0]][first->info->pos[1]+1].move = 'R';
							map[first->info->pos[0]][first->info->pos[1]+1].previous = new square;
							map[first->info->pos[0]][first->info->pos[1]+1].previous = &map[first->info->pos[0]][first->info->pos[1]];
							if (first->info->pos[0] < maxsquare->pos[0]) maxsquare = &map[first->info->pos[0]][first->info->pos[1]+1];
							else if ((first->info->pos[0] == maxsquare->pos[0]) && (first->info->pos[1]+1 < maxsquare->pos[1])) maxsquare = &map[first->info->pos[0]][first->info->pos[1]+1];
							this->push(map[first->info->pos[0]][first->info->pos[1]+1]);
						}
					}
					if (first->info->pos[0] - 1 >= 0){
						if (map[first->info->pos[0]-1][first->info->pos[1]].c != 'X' && map[first->info->pos[0]-1][first->info->pos[1]].visited == false){
							map[first->info->pos[0]-1][first->info->pos[1]].visited = true;
							map[first->info->pos[0]-1][first->info->pos[1]].move = 'U';
							map[first->info->pos[0]-1][first->info->pos[1]].previous = new square;
							map[first->info->pos[0]-1][first->info->pos[1]].previous = &map[first->info->pos[0]][first->info->pos[1]];
							if (first->info->pos[0]-1 < maxsquare->pos[0]) maxsquare = &map[first->info->pos[0]-1][first->info->pos[1]];
							else if ((first->info->pos[0]-1 == maxsquare->pos[0]) && (first->info->pos[1] < maxsquare->pos[1])) maxsquare = &map[first->info->pos[0]-1][first->info->pos[1]];
							this->push(map[first->info->pos[0]-1][first->info->pos[1]]);
						}
					}
					this->pop();
				}
				cout << "infinity" << endl;
				square *temp = new square;
				temp = maxsquare;
				while (temp->previous != nullptr) {
					path = temp->move + path;
					temp = temp->previous;
				}
				if ( path == "") cout << "stay\n";
				else cout << path << endl;
			}
		}
	private:
		node *first, *last;
};

int main(int argc, char **argv){
	ifstream infile;
	infile.open(argv[1]);
	char c;
	int N = 0, j=0, M = 0;
	queue flood, cat;	
	while(infile.get(c)){
		if(infile.eof()) break;
		if (c == '\n'){
		        N++;
			M = j;
			j=0;
		}
		else{
		       	map[N][j].c = c;
			map[N][j].pos[0] = N;
			map[N][j].pos[1] = j;
			if (c=='W') {
				map[N][j].time = 0;
				map[N][j].checked = true;
				flood.push(map[N][j]);
			}
			else if (c=='A'){
				map[N][j].t = 0;
				map[N][j].visited = true;
				cat.push(map[N][j]);
			}
			j++;
		}
	}
	flood.floodfill(N,M);
	cat.catpath(N, M);
}
