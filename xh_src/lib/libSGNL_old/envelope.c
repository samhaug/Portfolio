/* Envelope function */

#include <stdio.h>
#include <math.h>
#include "DComplex.h"
#include "xhhead.h"

#define MAX_NPTS 262144

int envelope(numsamp,f,fenv)

int numsamp;
  float *f,*fenv;
{
int i;
dcomplex x[MAX_NPTS];
float fin[MAX_NPTS], fhilb[MAX_NPTS];

if(numsamp<=0) { 
   fprintf(stderr,"%s\n","No data points read ....");
   return(0);
}
if( numsamp>MAX_NPTS) {
   fprintf(stderr,"%s\n","too many samples....");
   return(0);
}
for( i=0; i<numsamp; i++)       
  fin[i] = f[i];
for( i=numsamp; i<MAX_NPTS; i++)       
  fin[i] = 0.;

// hilbert transform
if (! hilbert(numsamp,fin,fhilb)) {
   fprintf(stderr,"hilbert() error ...\n");
   return(0);
}

for( i=0; i<numsamp; i++)       
  fenv[i] = sqrtf ( f[i]*f[i] + fhilb[i]*fhilb[i] );

return(1);
}
