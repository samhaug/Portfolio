// mean_sigma --  mean and sigma of a vector x[n]

#define MAX 1000000

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

void usage();

int mean_sigma(x, n, mean, sigma)
float x[MAX];
int n;
float *mean, *sigma;
{

float  mm = 0.;
float  ss = 0.;
int    i = 0;

// fprintf(stdout,"In mean_sigma(): x_0= %f n= %d\n", x[0], n);


if (n>= MAX) {
   fprintf(stderr,"mean_sigma() error ...  n= %d is great than MAX= %d\n", n, MAX);
   return(0);
}
// fprintf(stdout,"In mean_sigma(): n= %d\n", n);

for (i=0; i<n; i++) {
   mm = mm + x[i];
}
mm = mm/n;
for(i=0; i<n; i++) {
  ss = ss + (x[i] - mm)*(x[i] - mm);
}
ss = ss/n;
ss = sqrt(ss);

*mean  = mm;
*sigma = ss;

// fprintf(stdout,"In mean_sigma(): mean= %f sig= %f\n", mm, *sigma);

return(1);
}
