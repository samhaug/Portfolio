// findmin  -- find the minimum value in a vector

#define MAX 1000000

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int findmin(x, n, minv, iv)

float x[MAX];
int n;
float *minv;
int  *iv;
{

int       i, j;
float v;

if (n>= MAX) {
   fprintf(stderr,"findmin() error ...  n= %d is great than MAX= %d\n", n, MAX); 
   return(0);
}

v = x[0];
j = 0;
//fprintf(stdout," IN findmin() ... n= %d\n", n);
//fprintf(stdout," IN findmin() ... j= %d v= %f\n", j, v);
for (i=1; i<n; i++) { 
//fprintf(stdout," IN findmin() ... i= %d x= %f\n", i, x[i]);
  if (x[i] < v) {
     v = x[i];
     j = i;
     //fprintf(stdout," IN findmin() ... j= %d v= %f\n", j, v);
  }
}

*minv = v;
*iv = j;
return (1);
}
