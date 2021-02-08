#include <stdio.h>
#include <string.h>
#include <math.h>
//#include <malloc.h>
#include "xhhead.h"
#include "Complex.h"

// ------------------------------------------------------------
// Deconvolves data2 from data1 (each with numsamp samples)
// in the frequency domain:
// z(w)=data1/data2 ; conv = F-1 (z(w))
// Results goes into conv

int xh_deconvolve(data1,data2,conv,tshift,waterlevel,dt,numsamp)
float data1[];
float data2[];
float conv[];
float tshift;
float waterlevel;
float dt;
int numsamp;
{

int i, j;
int ierr;
int NFFT=8192;

int xh_detrend();

float omega;
double amp, ampmx;

fcomplex x1[8192],x2[8192],z[8192];
fcomplex imag;
fcomplex phase;

imag.r = 0.;  imag.i = 1.0;
if( numsamp>XH_NPTS) {
   fprintf(stderr,"deconvolve(): Number of samples exceed XH_NPTS ...");
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
// waterlevel filter 
ampmx = ccabs(x2[0]);
for( i=1; i<=(NFFT/2); i++ )
  if ( ccabs(x2[i]) > ampmx) ampmx = ccabs(x2[i]);
for( i=0; i<=(NFFT/2); i++ ) {
  amp = ccabs(x2[i]);
  if ( amp < waterlevel*ampmx) {
     x2[i].r = (float) waterlevel*ampmx*x2[i].r;
     x2[i].i = (float) waterlevel*ampmx*x2[i].i;
  }
}
  
// Divide x1 by x2
for( i=0; i<=(NFFT/2); i++ ) {
   omega = TPI*i/(NFFT*dt);
   phase.r = cos(omega*tshift);
   phase.i = -1.*sin(omega*tshift);
   z[i] = cdiv(x1[i],x2[i]);
   z[i] = cmltp(z[i],phase);
   // High-pass filter with f<4mHz (T>250s) to suppress long-period noise:
   if (omega/TPI < 0.004) {
     z[i].r = 0.;
     z[i].i = 0.;
   }
} // for loop

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
