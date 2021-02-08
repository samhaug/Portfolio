#include <stdio.h>
#include <stdlib.h>
#include <math.h>

/* 
       tapers a trace by
       applying a cosine taper to the first and last TAPER s of a trace
       y(i)  = original series
       dt    = sampling time interval 
       npts  = number of samples
*/

int taper(y, dt, npts, taptime)
     	float *y;
	float dt;
	int npts;
        float taptime;
{

double pi;
double arg, sinarg;
int i, nn;

pi = 4.*atan(1.);

nn = (int) rintf(taptime/dt);
if (nn < 2) {
   fprintf(stderr,"taper() nn = %d\n", nn);
   return(0);
}

for (i=0; i<nn; ++i) { 
  arg = pi/2.*(i*1.)/(nn-1);
  sinarg = sin(arg);
  y[i] *= sinarg*sinarg;
}
for (i=npts-nn; i<npts; ++i) { 
  arg = pi/2. - pi/2.*(i-npts+nn)*1./(nn-1);
  sinarg = sin(arg);
  y[i] *= sinarg*sinarg;
}

return(1);

}
