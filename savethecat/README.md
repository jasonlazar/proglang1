## Save the cat
In this problem we have an N*M grid. Each cell in the grid must either consist of one of: a) an obstacle ('X'), b) a broken water pump ('W'), c) nothing ('.'), d) the cat ('A'). Starting at time 0, every second that goes by every cell that has water will flood its adjacent cells (diagonals excluded) except the cells where there are obstacles. We are asked to output the moves that the cat must do every second in order to last the longer without getting wet. The moves can be up ('U'), down ('D'), left ('L') and right ('R').

For the solution we first run a flood fill algorithm to find the second every cell gets flooded. Then we begin a bfs from the cat's position to find the cell the path the cat must follow in order to survive as long as she can without us rescuing it.

The problem is solved in C++, Standard ML, Python and Java.
