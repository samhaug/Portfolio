/* Envelope function */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "DComplex.h"

#define MAX_NPTS 262144

int envelope(numsamp,f,fenv)

int numsamp;
float f[],fenv[];
{
int i;
dcomplex x[MAX_NPTS];
float fin[MAX_NPTS], fhilb[MAX_NPTS];

fprintf(stderr,"in envelope()\n");
if(numsamp<=0) { 
   fprintf(stderr,"%s\n","No data points read ....");
   return(0);
}
if( numsamp>MAX_NPTS) {
   fprintf(stderr,"%s\n","too many samples....");
   return(0);
}
fprintf(stderr,"in envelope(): numsamp= %d\n", numsamp);
for( i=0; i<numsamp; i++)       
  fin[i] = f[i];
fprintf(stderr,"in envelope(): b\n");
for( i=numsamp; i<MAX_NPTS; i++)       
  fin[i] = 0.;

fprintf(stderr,"in envelope(): c\n");
// hilbert transform
if (! hilbert(numsamp,fin,fhilb)) {
   fprintf(stderr,"hilbert() error ...\n");
   return(0);
}

fprintf(stderr,"in envelope(): numsamp= %d\n", numsamp);
for( i=0; i<numsamp; i++)       
  fenv[i] = sqrtf ( f[i]*f[i] + fhilb[i]*fhilb[i] );
fprintf(stderr,"exiting envelope(): numsamp= %d\n", numsamp);

return(1);
}
