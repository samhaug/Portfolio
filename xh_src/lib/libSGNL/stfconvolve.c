// Convolves traces with a triangular stf with half-duration hdur

#include <stdio.h>
#include <math.h>
#include "xhhead.h"
#include "DComplex.h"

#define MAX_NPTS 65536

int stfconvolve(hdur,numsamp,dt,f,filt)

float hdur;
int numsamp;
float dt;
float *f,*filt;
{
int i, j;
int NFFT = MAX_NPTS;;

float omega;
float stf, W;

dcomplex imag;
dcomplex x[MAX_NPTS];

imag.r = 0.;  imag.i = 1.0;

// Remove DC and linear trend
if (! detrend(f,numsamp))
   return(0);

// check number of samples
if(numsamp<=0) {
   fprintf(stderr,"%s\n","No data points read ....");
   return(0);
}
if( numsamp>MAX_NPTS ) {
   fprintf(stderr,"numsamp greater than %d\n", MAX_NPTS);
   return(0);
}

// Minimize NFFT to speed up fft(): MAX_NPTS must be 2**n !!
NFFT = MAX_NPTS;
while (NFFT/2 >=numsamp) {
  NFFT = NFFT/2;
}

// fill complex arrays "x" with the data
for( i=0; i<numsamp; i++) {
   x[i].r = f[i]; x[i].i = 0.;
}
for(i=numsamp; i<NFFT; i++) {
   x[i].r = 0.;   x[i].i = 0.;
}

// Fourier transform to FREQ domain
dfft( x,NFFT,-1 );

// Multiply with the Fourier trasform of a triangle with base: 2*hdur
// This is: sinW*sinW/(W*W), where W = omega*hdur/2

for( i=0; i<=(NFFT/2); i++ ) {
   omega = TPI*i/(NFFT*dt);
   if (i == 0) {
      stf = 1.;
   } else {
      W = omega*hdur/2.;
      stf = sin(W)*sin(W) / (W*W);
      x[i] = dmltp(stf,x[i]);
      // fprintf(stdout,"freq= %f stf= %f\n", omega/TPI, stf);
   }
}
x[0].r=0.; x[0].i=0.;

// Mirror around NFFT/2
for( i=(NFFT/2)+1; i<NFFT; i++ ) x[i] = dconjg(x[NFFT-i]);
// Inverse Fourier transform to TIME domain
dfft( x,NFFT,1 );
// Real part of x is the deconvolved seismogram
for( i=0; i<numsamp; i++ ) filt[i] = x[i].r;
// Remove DC and linear trend
if (! detrend(filt,numsamp)) return(0);

return(1);
}
