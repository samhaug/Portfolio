#include <stdio.h>
#include <math.h>
// Detrend seismograms from average offset and slope

int detrend(x, n)
float *x;
int n;
{
  float ds1,ds2,dan,davei,davex,dslope,dai;
  int i, an;
  
  an = n;
  dan=n;
  ds1=0;
  ds2=0;
  
  if (n==0) {
    fprintf(stderr,"xh_detrend() error; number samples is 0\n");
    return (0);
  }
  for(i=0; i<n; ++i) {
    ds1 = ds1+ x[i];
    ds2 = ds2 + ds1;
  }
  davei = 0.5 * (dan+1.0);
  davex = ds1/dan;
  dslope = -12.0*(ds2-davei*ds1)/(dan*(dan*dan-1.0));
  for(i=0; i<n; ++i) {
    dai = i;
    x[i] = x[i]- davex - dslope*(dai-davei);
  }
  return (1);
}
