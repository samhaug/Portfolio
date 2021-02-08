#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "DComplex.h"

#define MAX_NPTS 65536

int hilbert(numsamp,f,fhilb)

int numsamp;
float f[],fhilb[];
//float *f, *fhilb;
{

int i, j;
int NFFT = MAX_NPTS;
dcomplex imag;
dcomplex x[MAX_NPTS];

imag.r = 0.;  imag.i = 1.0;

// check number of samples
if(numsamp<=0) {
   fprintf(stderr,"%s\n","No data points read ....");
   return(0);
}
if( numsamp>MAX_NPTS ) {
    fprintf(stderr,"%s\n","nsamp greater than MAX_NPTS ...");
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

// forward FFT 
dfft( x,NFFT,-1 );

// Multiply the spectrum by imag=cmplx(0,1)
for (i=0; i<=(NFFT/2); ++i)
  x[i] = dcmltp(x[i],imag);

x[0].r = 0.;
x[0].i = 0.;

// mirror around NFFT/2
for( i=(NFFT/2)+1; i<NFFT; i++ ) x[i] = dconjg(x[NFFT-i]);
// Inverse Fourier transform to TIME domain
dfft( x,NFFT,1 );
// Real part of x is the deconvolved seismogram
for( i=0; i<numsamp; i++)
    fhilb[i] = x[i].r;
// Remove DC and linear trend
if (! detrend(fhilb, numsamp))
   return(0);

return(1);
}
