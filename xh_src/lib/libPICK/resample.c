#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define npts_dat 8192  /* Maximum number of samples in time series */
#define npts_crc 4000  /* Maximum number of samples in traces used in cross_correlation  */

void resample(trace,t,Samp,window,decim)

/* Resamples TRACE --> t
   {New_sampling_rate} / {Old_sampling_rate} = decim
*/

float     *trace, *t;
int        Samp, window, decim;

{
       int i, j, k, isamp;
       float a, b, rat;

k = 2*window*decim;
if ( k > npts_crc) {
   fprintf(stderr,"in RESAMPLE: %d greater than npts_crc [%d]\n", k, npts_crc);
   exit (-1);
}

/*
fprintf(stdout,"in RESAMPLE: Samp= %d window= %d decim= %d\n", Samp, window, decim);
*/

k = -1;
for (i= (Samp-window); i<= (Samp+window); ++i) {
   k++;
   a = trace[i]; b = trace[i+1];
   /* fprintf(stdout,"in RESAMPLE: i= %d  a= %f b= %f\n", i,a,b); */
   rat = (b-a)/decim;
   isamp = k*decim;
   for(j=0; j<decim; ++j) {
       t[isamp+j] = a+rat*j; 
   }
}
}
