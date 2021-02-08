// Filtering using a Bandpass frequency filter

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "xhhead.h"
#include "DComplex.h"

#define MAX_NPTS 65536


int bpfilter(f1,f2,f3,f4,numsamp,dt,f,filt)

int f1,f2,f3,f4;
int numsamp;
float dt;
float *f,*filt;
{
int i, j;
int NFFT = MAX_NPTS;;

float omega;
float bpfilt=0;

dcomplex imag;
dcomplex x[MAX_NPTS];

int detrend(), bpf();

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

// fprintf(stdout,"in bpfilter() c3\n");
// fill complex arrays "x" with the data
for( i=0; i<numsamp; i++) {
   x[i].r = f[i]; x[i].i = 0.;
}
for(i=numsamp; i<NFFT; i++) {
   x[i].r = 0.;   x[i].i = 0.;
}

// Fourier transform to FREQ domain
dfft( x,NFFT,-1 );

// Filter
for( i=0; i<=(NFFT/2); i++ ) {
   omega = TPI*i/(NFFT*dt);
   // bpfilt is the amplitude of the cos**2 filter
   // to be multiplied by x[i]
   if (! bpf(f1,f2,f3,f4,omega,&bpfilt))
      return(0);
   x[i] = dmltp(bpfilt,x[i]);
}
x[0].r=0.; x[0].i=0.;

// Mirror around NFFT/2
for( i=(NFFT/2)+1; i<NFFT; i++ ) x[i] = dconjg(x[NFFT-i]);
// Inverse Fourier transform to TIME domain
dfft( x,NFFT,1 );
// Real part of x is the deconvolved seismogram
for( i=0; i<numsamp; i++ ) {
   filt[i] = x[i].r;
}
// Remove DC and linear trend
if (! detrend(filt,numsamp))
   return(0);

return(1);
}
