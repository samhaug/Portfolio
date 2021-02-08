// Finds the shift SHIFT of seis2 that
// render the highest cross-correlation
// between seis1 and seis2

// Assumes that the shift is within 9s.

#include <stdio.h>
#include <math.h>

int crosscor(seis1,seis2,numsamp,dt,ts)
float *seis1;
float *seis2;
float dt;
int   numsamp;
float *ts;
{

int i, k1,k2;
int i_9s;
float v, maxcor = 0.;

int i_bestShift=0;

i_9s = (int) (9./dt);

for (i=-i_9s; i<=i_9s; i++) {
  v=0.;
  for (k1=0;k1<numsamp;k1++) {
    k2=k1+i; 
    if(k2>=0 && k2<numsamp) {
      v=v+seis1[k1]*seis2[k2]; 
    }
  }
  // fprintf(stdout,"Xcor: i=%d ts = %7.2f  v= %11.4e\n", i,i*dt,v);
  if ( v>maxcor ) {
    maxcor = v;
    i_bestShift = i;
  }
}
*ts = i_bestShift*dt;

if(maxcor == 0) {
  fprintf(stderr,"crosscor(): error ...\n");
  return(0);
}

return(1);
}
