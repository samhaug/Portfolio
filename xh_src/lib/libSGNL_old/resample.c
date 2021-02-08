#include <stdio.h>
#include <string.h>
#include <math.h>

#define MAX 10000

// resample -- reads in file with 2 columns (i.e. seismogram)
// and resample it with NEWdt

int resample(f, n, fac)
float   f[];
int     fac;
int     n;
{

int       i, j;
float     fnew[MAX];
float     dfdx;
  



if (n*fac > MAX) {
     fprintf(stderr,"ERROR resample() increase MAX ...\n");
     return(0);
}

for (i=0; i<n; i++) {
  dfdx = (f[i+1]-f[i])/fac;
  for (j=0; j< fac; j++) {
    fnew[i*fac + j] = f[i]+j*dfdx;
  }
}
for (i=0; i<n; i++) {
  for (j=0; j< fac; j++) {
    f[i*fac + j] = fnew[i*fac + j];
  }
}

return(1);
}
