// Phase stacking;
// See Maarten Schimmel's thesis (page 32)

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "xhhead.h"
#include "Complex.h"

int phasestacking(numsamp,f,p_real,p_imag)

int numsamp;
float *f,*p_real,*p_imag;
{

	int i, j;
	float *fhilb;
	double arg;
        int hilbert();

fhilb = (float *)malloc(sizeof(float)*numsamp);

if(numsamp<=0) {
   fprintf(stderr,"phasestacking(): no data points read ...\n");
   return(0);
}

for(i=0; i<numsamp; i++) { 
  p_real[i] = 0.;
  p_imag[i] = 0.;
}

// hilbert transform
if (! hilbert(numsamp,f,fhilb))
  return(0);

for( i=0; i<numsamp; i++) { 
  arg       = atan2( (double)fhilb[i], (double)f[i] );
  p_real[i] = (float) cos(arg);
  p_imag[i] = (float) sin(arg);
}

return(1);
}
