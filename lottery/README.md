## Lottery
In this problem we have N different lottery tickets each of which is a number consisting of K digits. We also have Q possible winning numbers and we are asked to compute the total amount of money won for each one mod 10e9 + 7. Each lottery wins 2^(M-1) money if it has its last M digits same with the winning number.

In order to solve this we make a trie where we keep all our N different tickets. For each of the Q queries we just have to traverse the trie and make the calculation.

The problem is solved Standard ML and Prolog.
