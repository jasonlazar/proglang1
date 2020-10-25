#include<stdio.h>

int main(int arc, char **argv){
	FILE *fp;
	int N, K, seen=0, i, first, last;
	if ((fp = fopen(argv[1], "rt")) == NULL) return 1;
	if (fscanf(fp, "%d %d", &N, &K) != 2) return 1;
	int a[N], count[K];
	for (i = 0; i<N; i++) if (fscanf(fp, "%d", &a[i]) != 1) return 1;
	fclose(fp);
	first = 0;
	int length = N + 1;
	for (i = 0; i<K; i++) count[i] = 0;
	for (last = 0; last<N; last++){
		++count[a[last]-1];
		if (count[a[last]-1]==1) seen++;
		if (seen == K){
			if (last-first+1<length) length = last - first + 1;
			count[a[first]-1]--;
                        first++;
			while(count[a[first-1]-1] > 0) {
				count[a[first]-1]--;
				first++;
			}
			if (last-first+2<length) length = last - first + 2;
			seen--;
		}
	}
	if (length == N+1) length = 0;
	printf("%d\n", length);
	return 0;
}
