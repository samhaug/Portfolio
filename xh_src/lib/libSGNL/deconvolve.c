#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "xhhead.h"
#include "Complex.h"

// ------------------------------------------------------------
// Deconvolves stf from seism (each with numsamp samples)
// in the frequency domain (--> z=seism/stf).
//
// See:
// Zhu and Kanamori, J. Geophys. Res. 105, 2969--2980, 2000
//
//  		    seism*conjg(stf)
// z(w) = (1+c) *  ------------------ * exp{-[omega/(omega_0)]**2}
// 	             (1+c)*stf*stf   

#define NSAMP 2048

int deconvolve(seism,stf,recf,tshift,c,dt,numsamp)
float seism[];
float stf[];
float recf[];
float tshift;
float c;		// waterlevel
float dt;
int numsamp;
{

int i, j;
int ierr;
int NFFT;

float omega;
float filt;
float dum;

fcomplex Rw[NSAMP],Sw[NSAMP],z[NSAMP];
fcomplex imag;
fcomplex phase;
fcomplex numerator;
double    denominator;

float omega_0 = 1.0*TPI; 	// filter freq of 1.0 Hz
float sigma_0 = 0.;		// auto-correlation of stf
for( i=0; i<numsamp; i++) 
  sigma_0 = sigma_0 + stf[i]*stf[i];

imag.r = 0.;  imag.i = 1.0;
if( numsamp>NSAMP) {
   fprintf(stderr,"deconvolve(): Number of samples exceed NSAMP ...");
   return(0);
}
// Minimize NFFT to speed up fft(); XH_NPTS MUST be 2**(int)n
NFFT = NSAMP;
while (NFFT/2 >=numsamp) {
  NFFT = NFFT/2;
}

for( i=0; i<numsamp; i++)   {
   Rw[i].r = seism[i]; Rw[i].i = 0.;
   Sw[i].r = stf[i];   Sw[i].i = 0.;
}
for(i=numsamp; i<NFFT; i++) {
   Rw[i].r = 0.;       Rw[i].i = 0.;
   Sw[i].r = 0.;       Sw[i].i = 0.;
}
// Fourier transform to FREQ domain
fft( Rw,NFFT,-1 );
fft( Sw,NFFT,-1 );

dum=0.;
for( i=0; i<=(NFFT/2); i++ )
 dum = dum + csqr(Sw[i]);
fprintf(stdout,"dum= %11.3e dum2 %11.3e \n", dum/(NFFT/2), c*sigma_0);
  
// Divide Rw by Sw (following Zhu)
for( i=0; i<=(NFFT/2); i++ ) {
   omega = TPI*i/(NFFT*dt);
   filt = 0.;
   filt = i/(NFFT*dt);
   filt = -1.0*filt*filt;
   filt = exp(filt);
   phase.r = cos(omega*tshift);
   phase.i = -1.*sin(omega*tshift);

   numerator   = cmltp( Rw[i],conjg(Sw[i]) );
   //numerator   = dmltp( filt,numerator );
   denominator = csqr(Sw[i]);
   dum = denominator;
   denominator = denominator + (double) (NFFT/2)*c*sigma_0;
   z[i] = dmltp( 1./denominator,numerator );
//    fprintf(stdout,"z= %f %f \n", z[i].r, z[i].i);

   z[i] = cmltp( phase,z[i] );
   // High-pass filter with f<125mHz (T>80s) to suppress long-period noise:
   if (omega/TPI < 0.0125) {
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
for( i=0; i<numsamp; i++ ) recf[i] = (1+c) * (NFFT/2*dt)*z[i].r;

// Remove DC and linear trend
if (! detrend(recf, numsamp)) return(0);

return (1);
}
