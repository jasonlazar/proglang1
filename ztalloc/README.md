## Ztalloc
Suppose we have a computer that can store integer numbers between 0 and 999999 and can only perform two calculations:
- h: x -> x div 2
- t: x -> 3*x + 1

We are asked to find the minimum sequence of calculations after which every number in range [Lin, Rin] will be mapped to [Lout, Rout].

In order to do that we keep a queue where we place each tuple (L, R) we can produce from (Lin, Rin) until we find one where L >= Lout and R <= Rout.

This problem is solved in Python, Prolog and Java.
