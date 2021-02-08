#include <stdio.h>
#include <string.h>
#include <math.h>
//#include <malloc.h>
#include "xhhead.h"
#include "Complex.h"

// ------------------------------------------------------------
// Divide data1 by data2 (each with numsamp samples) in the frequency domain:
// z(w)=data1/data2; 
// lnR = ln[z(w).r] (i.e., log of real part of z(w))

int xh_dtstar(data1,data2,lnR,dt,numsamp,dw,numfreq)
float  data1[];
float  data2[];
float  lnR[];
float  dt;
int    numsamp;
float *dw;
int   *numfreq;
{

int i, j;
int NFFT=8192;

float twopi;
float omega;

fcomplex x1[8192],x2[8192],z[8192];
fcomplex imag;
imag.r = 0.;  imag.i = 1.0;
twopi = 8. * atan(1.);


if( numsamp>XH_NPTS) {
   fprintf(stderr,"xh_dtstar(): Number of samples exceed XH_NPTS ...\n");
   return(0);
}
// Minimize NFFT to speed up fft(); XH_NPTS MUST be 2**(int)n
NFFT = XH_NPTS;
while (NFFT/2 >=numsamp) {
  NFFT = NFFT/2;
}

for( i=0; i<numsamp; i++)   {
   x1[i].r = data1[i]; x1[i].i = 0.;
   x2[i].r = data2[i]; x2[i].i = 0.;
}
for(i=numsamp; i<NFFT; i++) {
   x1[i].r = 0.;   x1[i].i = 0.;
   x2[i].r = 0.;   x2[i].i = 0.;
}
// Fourier transform to FREQ domain
fft( x1,NFFT,-1 );
fft( x2,NFFT,-1 );

// Divide x1 by x2
for( i=0; i<=(NFFT/2); i++ ) {
   omega  = twopi*i/(NFFT*dt);
   z[i]   = cdiv(x2[i],x1[i]);
   lnR[i] = z[i].r;
   lnR[i] = log(z[i].r);
   //lnR[i] = sqrt (z[i].r*z[i].r + z[i].i*z[i].i);
}
*dw = twopi/(NFFT*dt);
*numfreq = (NFFT/2) + 1;

return (1);
}
