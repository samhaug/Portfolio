/*
 * signallevel  - Determines the maximum peak-to-trough
                  signal amplitude between i1 and i2
 *
 */

#include <stdio.h>
#include <string.h>
#include <math.h>


void signallevel(i1, i2, data, mode, signal,log)

   int      i1, i2, mode;
   float   *data;
   float   *signal;
   FILE    *log;
{

int i, j1,j2, k;
float recmin, recmax;
float  max1, max2;

*signal = 0.;

/*
fprintf(stdout,"SIGNALLEVEL: mode= %d i1= %d i2= %d\n", mode, i1, i2);
*/
fprintf(log,"SIGNALLEVEL: mode= %d i1= %d i2= %d\n", mode, i1, i2);


recmax = data[i1]; recmin = data[i1];



if (mode == 1 ) {
  /*--- Peak-to-trough signal level --------------*/
  for(i=i1+1; i< i2; ++i) {
    if (data[i] > recmax) recmax=data[i];
    if (data[i] < recmin) recmin=data[i];
  }
  *signal = (recmax - recmin)/2.;
  fprintf(log,"Amplitude= %7.2f\n", *signal);
}



if (mode == 2 ) {
  /*--- Envelope signal --------------------------*/
  /*--- Here, we determine the ratio between the maximum and a
        preceeding secondary maximum amplitude in the ENVELOPE trace.
  */

  k = i1;
  /* Find sample K at the maximum amplitude: */
  for(i=i1+1; i< i2; ++i) {
    if (data[i] > recmax) {
      recmax=data[i];
      k = i;
    }
  }
  max1 = data[i1]; max2 = data[i2];
/*
fprintf(stdout,"k= %d recmax= %f max1= %f max2= %f\n", k, recmax, max1, max2);
*/
  j1 = j2 = k;
/*
fprintf(stdout,"j1= %d j2= %d\n", j1, j2);
*/

       max2 = 0.;
       /* ------  SKIP THIS FOR NOW ....
       Find the secondary maximum amplitude to the right of sample K:
       First find the "bottom"
       for(i=k+1; i< i2; ++i) {
         if (data[i] < data[i-1]) {
           j2 = i;
         } else {
           break;
         }
       }
       Then find the next peak:
       for(i=j2+1; i< i2; ++i) {
         if (data[i] < data[i-1]) {
           max2 = data[i];
           break;
         }
       }
       ------------------------------ */

  /* Find the secondary maximum amplitude to the left of sample K: */
  /* First find the "bottom" */
  for(i=k-1; i> i1; --i) {
    if (data[i] < data[i+1]) {
      j1 = i;
    } else {
      break;
    }
  }
  /* Then find the next peak: */
  for(i=j1-1; i> i1; --i) {
    if (data[i] < data[i+1]) {
      max1 = data[i];
      break;
    }
  }
  if (max1 > max2) {
    *signal = recmax/max1;
  } else {
    *signal = recmax/max2;
  }
/*
  fprintf(stdout,"SIGNALLEVEL: k= %d j1= %d j2= %d max1= %f max2= %f recmax= %f\n",
                    k, j1, j2, max1, max2, recmax);
*/

/*
  fprintf(stdout,"signal= %7.2f\n", *signal);
*/
  fprintf(log,"Envelope Amplitude= %7.2f\n", *signal);
}

return;
}

