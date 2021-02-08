/* Envelope function */

#include <stdio.h>
#include <math.h>
#include "dcmath.h"
#include "parameter.h"

void envelope(numsamp,f,fenv)

int numsamp;
float *f,*fenv;
{

	int i, j;
	dcomplex imag;
	dcomplex x[npts_dat];
	void detrend();
	float fhilb[npts_dat];

/* fprintf(stdout,"IN ENVELOPE  numsamp= %d\n", numsamp); */

if(numsamp<=0) 
   fprintf(stderr,"%s\n","No data points read ....");
if( numsamp>npts_dat )
    fprintf(stderr,"%s\n","too many samples....");
for(i=0; i<npts_dat; i++)       
  fenv[i] = 0.;


/* f is input signal; fhilbert is hilbert transform of f */
hilbert(numsamp,f,fhilb);

for( i=0; i<numsamp; i++)       
  fenv[i] = sqrt( f[i]*f[i] + fhilb[i]*fhilb[i] );

return;
}
