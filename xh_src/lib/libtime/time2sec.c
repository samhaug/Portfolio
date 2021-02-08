#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "time.h"

/* Calendar days */

static int      dim[2][13] = {
        {0,31,28,31,30,31,30,31,31,30,31,30,31},
        {0,31,29,31,30,31,30,31,31,30,31,30,31},
};
static int      eom[2][13] = {
        {0,31,59,90,120,151,181,212,243,273,304,334,365},
        {0,31,60,91,121,152,182,213,244,274,305,335,366},
};


/* Converting the TIME_ARRAY
to amount in seconds since 1970

WORKS ONLY FOR DATES AFTER 1970 !!!
(see xh_time of /work/jeroen/inc/time.h):
*/

int time2sec(tm, ts)
xh_time tm;
double *ts;

{
int i, k;
int numly = 0;


if (tm.yr  < 1970)              return(0);
if (tm.mo  < 1 ||  tm.mo  > 12) return(0);
if (tm.day < 1 ||  tm.day > 31) return(0);
if (tm.hr  < 0 ||  tm.hr  > 23) return(0);
if (tm.mn  < 0 ||  tm.mn  > 59) return(0);

*ts = 0.;

for (i=1970; i<tm.yr;i++) {
   *ts  = *ts + 365*24*3600.;
   if (isleap(i) == 1) {
      numly++;
      *ts = *ts +   24*3600.;
   }
}
k = isleap(tm.yr);
*ts = *ts + eom[k][tm.mo-1]*24*3600.;

for (i=1; i<tm.day;i++) {
   *ts = *ts + 24*3600.;
}

*ts = *ts + tm.hr*3600.;
*ts = *ts + tm.mn*60.;

*ts = *ts + tm.sec;

return(1);
}
