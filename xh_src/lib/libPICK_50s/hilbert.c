/* Applying the Hilbert transform (multiply the FFT by i */

#include <stdio.h>
#include <math.h>
#include "dcmath.h"
#include "parameter.h"

void hilbert(numsamp,f,fhilb)

int numsamp;
float *f,*fhilb;
{

int i, j;
double bpfilt;
dcomplex imag;
dcomplex x[npts_dat];
void detrend();

imag.re = 0.;  imag.im = 1.0;

for(i=0; i<npts_dat; i++)       
  fhilb[i] = 0.;

if(numsamp<=0) 
   fprintf(stderr,"%s\n","No data points read ....");

if( numsamp>npts_dat )
    fprintf(stderr,"%s\n","too many samples....nsamp greater than npts_dat");

for( i=0; i<numsamp; i++)   
   {
   x[i].re = (double) f[i]; 
   x[i].im = 0.;
   }
for(i=numsamp; i<npts_dat; i++) 
  x[i].re = x[i].im = 0.;

/* Forward FFT */
cfft( x,npts_dat,-1 );

/* Multiply the spectrum by i=(0,1) */
for (i=1; i<=npts_dat/2; ++i)
  { 
  x[i] = dcmult(x[i],imag);
  }

x[0].re = 0.;
x[0].im = 0.;

for( i=(npts_dat/2)+1; i<npts_dat; i++ ) 
  x[i] = dconj(x[npts_dat-i]);

/* Inverse FFT */
cfft( x,npts_dat,1 );

for( i=0; i<numsamp; i++)       
  fhilb[i] = x[i].re/npts_dat;

detrend(fhilb, numsamp);
return;
}
