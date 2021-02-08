// Applies a time shift to the trace;
// primarily used for CMT synthetics,
// incorporating the origin time shift in the CMT solution

#include <stdio.h>
#include <math.h>

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
  k0 = (int) ceilf(-1.*tshift/dt);
  deriv = ( k0*dt + tshift )/dt;
  for(i=1;i<numsamp-k0-1;i++) {
    fnew[i] = f[i+k0] - deriv*( f[i]-f[i-1] );
  }
  // ENDPOINTS of FNEW by linear interpolation
  deriv = fnew[numsamp-k0-2]-fnew[numsamp-k0-3];
  for(i=numsamp-k0-1; i<=numsamp-1; i++) {
    fnew[i] = fnew[i-1] + deriv;
  }
  // BEGIN POINT
  fnew[0] = 2*fnew[1]-fnew[2];
  return(1);
} else {
  k0 = (int) ceilf(tshift/dt);
  // project F into FNEW after shifting by k0 and
  // linear interpolation between F[i] and F[i+1]
  deriv = ( k0*dt - tshift )/dt;
  for(i=0;i<numsamp-k0-1;i++) {
    fnew[i+k0] = f[i] + deriv*( f[i+1]-f[i] );
  }
  // END POINT
  fnew[numsamp-1] = 2*fnew[numsamp-2]-fnew[numsamp-3];

  // DEFINE the beginning of FNEW by linear interpolation
  deriv = fnew[k0+1] - fnew[k0];
  for(i=k0-1;i>=0;i--) {
    fnew[i] = fnew[i+1] - deriv;
  }
  return(1);
}
}
