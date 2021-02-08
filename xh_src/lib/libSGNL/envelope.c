#include <stdio.h>
#include <math.h>

#define npts_dat 65536

int envelope(numsamp,f,fenv)

int numsamp;
float f[];
float fenv[];
{

	int i, j;
    int n;
	float fhilb[npts_dat];
	float fin[npts_dat];


if(numsamp<=0) 
   fprintf(stderr,"%s\n","No data points read ....");
if( numsamp>npts_dat )
    fprintf(stderr,"%s\n","too many samples....");
for(i=0; i<npts_dat; i++)       
  fin[i] = 0.;
for(i=0; i<npts_dat; i++)       
  fhilb[i] = 0.;


j = hilbert(numsamp,fin,fhilb);

for( i=0; i<numsamp; i++)       
  fenv[i] = sqrt( f[i]*f[i] + fhilb[i]*fhilb[i] );

return (1);
}
