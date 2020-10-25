## Colors
In this problem we are given an array of N integers. We want to find the length of the smallest subarray that contains all values between 0 and K-1.

In order to solve this we keep two pointers f and l that point to the first and last element of a subarray. We start each from 0 and in each iteration we increment l. We also keep an array that counts how much times each number is contained in the subarray we are examining. Once we have encountered all values we check how much we can move the f pointer while the subarray still has all values. 

The problem is solved in C, Standard ML and Prolog.
