// Applies a time shift to the trace;
// primarily used for CMT synthetics,
// incorporating the origin time shift in the CMT solution

#include <stdio.h>
#include <math.h>
#include "/work/jeroen/inc/xhhead.h"
#include "/work/jeroen/inc/Complex.h"

int timeshift(tshift,numsamp,dt,f,fnew)
    float tshift;
    int numsamp;
    float dt;
    float *f,*fnew;
    {

    int i;
    int k0;
    float deriv;

    // check number of samples
    if(numsamp<=0) {
       fprintf(stderr,"%s\n","No data points read ....");
       return(0);
    }

    if (tshift < 0.) {
      fprintf(stderr,"TSHIFT must be larger than 0 ...\n");
      return(0);
    } else {
      k0 = rintf(ceilf(tshift/dt));
      // project F into FNEW after shifting by k0
      deriv = ( k0*dt - tshift )/dt;
      for(i=0;i<numsamp-k0-1;i++) {
        fnew[i+k0] = f[i] + deriv*( f[i+1]-f[i] );
      }
      fnew[numsamp-1] = fnew[numsamp-2];

      // DEFINE the beginning of FNEW by linear interpolation
      deriv = fnew[k0+1] - fnew[k0];
      for(i=k0-1;i>=0;i--) {
        fnew[i] = f[i+1] - deriv;
      }
      return(1);
    }
}
