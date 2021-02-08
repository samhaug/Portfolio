// Phase stacking;
// See Maarten Schimmel's thesis (page 32)

#include <stdio.h>
#include <math.h>
#include "/work/jeroen/inc/xhhead.h"
#include "/work/jeroen/inc/Complex.h"

int phasestacking(numsamp,f,p_real,p_imag)

int numsamp;
float *f,*p_real,*p_imag;
{

	int i, j;
	float fhilb[XH_NPTS];
	double arg;
        int hilbert();

fprintf(stdout,"in phasestacking(): numsamp = %d\n", numsamp);
if(numsamp<=0) {
   fprintf(stderr,"phasestacking(): no data points read ...\n");
   return(0);
}
if( numsamp>XH_NPTS ) {
   fprintf(stderr,"phasestacking(): numsamp exceeds XH_NPTS ...\n");
   return(0);
}

for(i=0; i<XH_NPTS; i++) { 
  p_real[i] = 0.;
  p_imag[i] = 0.;
}

// hilbert transform
fprintf(stdout,"going into hilbert() numsamp = %d\n", numsamp);
if (! hilbert(numsamp,f,fhilb))
  return(0);
fprintf(stdout,"coming out of hilbert() numsamp = %d\n", numsamp);

for( i=0; i<numsamp; i++) { 
  arg       = atan2( (double)fhilb[i], (double)f[i] );
  p_real[i] = (float) cos(arg);
  p_imag[i] = (float) sin(arg);
}

return(1);
}
