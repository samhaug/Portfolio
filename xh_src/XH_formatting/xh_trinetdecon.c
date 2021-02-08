#include <stdio.h>
#include <string.h>
#include <math.h>
#include <malloc.h>
#include "/home/jeroen/inc/xhhead.h"
#include "/home/jeroen/inc/Complex.h"

// ------------------------------------------------------------
// Deconvolves data2 from data1 (each with numsamp samples)
// in the frequency domain:
// z(w)=data1/data2 ; conv = F-1 (z(w))
// Results goes into conv

// NPTS MUST be 2**(int)n
#define NPTS = 131072

int xh_deconvolve(data1,data2,conv,dt,numsamp)
float data1[];
float data2[];
float conv[];
float dt;
int numsamp;
{

int i, j;
int ierr;
int NFFT;

float omega;
float TPI   = 6.283185307179586;

fcomplex x1[NPTS],x2[NPTS],z[NPTS];
fcomplex imag;

fprintf(stdout,"in xh_deconvolve numsamp= %d\n", numsamp);
imag.r = 0.;  imag.i = 1.0;
fprintf(stdout,"B1\n");
if( numsamp>NPTS) {
   fprintf(stderr,"deconvolve(): Number of samples exceed NPTS ...");
   return(0);
}
// Minimize NFFT to speed up fft()
fprintf(stdout,"B1\n");
NFFT = NPTS;
while (NFFT/2 >=numsamp) {
  NFFT = NFFT/2;
}
// fill complex arrays "x1" and "x2" with the data
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
   omega = TPI*i/(NFFT*dt);
   z[i] = cdiv(x1[i],x2[i]);
}

// Mirror around NFFT/2
for( i=(NFFT/2)+1; i<NFFT; i++ ) z[i] = conjg(z[NFFT-i]);

// Inverse Fourier transform to TIME domain
fft( z,NFFT,1 );

// Real part of x is the deconvolved seismogram
// I do not think that we have to divide by NFFT or dt;
// but I will need to verify this ... (jeroen ritsema)
for( i=0; i<numsamp; i++ ) conv[i] = z[i].r;

// Remove DC and linear trend
if (! xh_detrend(conv, numsamp)) return(0);

return (1);
}
