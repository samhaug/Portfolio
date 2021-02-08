#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "time.h"

/* --
Adds "TS" seconds to tm1,
and place the result in tm2
-- */

/* days in the month */
static int      dim[2][13] = {
        {0,31,28,31,30,31,30,31,31,30,31,30,31},
        {0,31,29,31,30,31,30,31,31,30,31,30,31},
};
/* accumulated number of days in the month */
static int      eom[2][13] = {
        {0,31,59,90,120,151,181,212,243,273,304,334,365},
        {0,31,60,91,121,152,182,213,244,274,305,335,366},
};


/* Adding TIME (in sec) to the TIME_ARRAY
(see xh_time of /work/jeroen/inc/time.h):
*/

int timadd(tm1, ts, tm2)

xh_time tm1, *tm2;
float ts;
{
double t;

if (tm1.yr  < 1970  || 
    tm1.mo  < 1 ||  tm1.mo > 12 ||
    tm1.day < 1 || tm1.day > 31 ||
    tm1.hr  < 0 ||  tm1.hr > 23 ||
    tm1.mn  < 0 ||  tm1.mn > 59) {
    fprintf(stderr,"TIMADD: input t-array has invalid entries ...\n");
    return(0);
}

time2sec(tm1, &t);
t = t + ts;
sec2time(tm2, t);

return(1);
}
