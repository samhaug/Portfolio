#include <stdio.h>
#include <string.h>
#include <math.h>

#define npts_dat 8192  /* Maximum number of samples in time series */
#define npts_crc 4000  /* Maximum number of samples in traces used in cross_correlation  */



/* L2fit: Determines the least-squares fit of
   TRACE2 (after a shift of i_crcor) to TRACE1.
   over a time window WINDOW
*/

float L2fit(trace1,trace2,i_crcor,window,log)

	float *trace1, *trace2;
        int    i_crcor;
        int    window;
        FILE  *log ;
{

          int       i;
          int       w2, iw1, iw2;
          float     amp1 = 0., amp2 = 0.;
          float     t1[npts_dat], t2[npts_dat];
          float     f, fit=0., nullfit=0.;



/*
fprintf(stdout,"in L2fit: i_crcor= %d window= %d\n", i_crcor, window);
fprintf(log,"in L2fit: i_crcor= %d window= %d\n", i_crcor, window);
*/

for (i=0; i< npts_dat; ++i) {
   t1[i] = trace1[i]; t2[i] = trace2[i];
}

w2  = window/2;
iw1 = window-w2;
iw2 = window+w2;

/* Normalise amplitude of TRACE1 and TRACE2 */
for(i= iw1; i<= iw2; ++i) {
  if ( fabs(t1[i]) > amp1 ) amp1 = fabs(t1[i]);
  if ( fabs(t2[i]) > amp2 ) amp2 = fabs(t2[i]);
}
for(i= 0; i<= 2*window; ++i) {
  t1[i] = t1[i] / amp1;
  t2[i] = t2[i] / amp2;
}

for(i= iw1; i<= iw2; ++i) {
  if ( (i-i_crcor) >= 0 && (i-i_crcor) <= 2*window) {
     f = t1[i] - t2[i-i_crcor];
     fit = fit + f*f;
     nullfit = nullfit + t1[i]*t1[i]; 
  }
}

/*
fprintf(stdout,"Fit= %f NullFit= %f 1.-Fit/Nullfit= %f\n", fit, nullfit, 1.-fit/nullfit);
fprintf(log,"Fit= %f NullFit= %f 1.-Fit/Nullfit= %f\n", fit, nullfit, 1.-fit/nullfit);
*/

fit = 1. - fit/nullfit;

return( fit );
}
