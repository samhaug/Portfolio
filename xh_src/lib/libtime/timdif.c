#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "time.h"

/* --
Finds the difference in seconds between
tm1, and tm2 and places the result in TS

(see xh_time of /work/jeroen/inc/time.h):
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


int timdif(tm1, tm2, ts)

xh_time tm1, tm2;
float *ts;
{
double t1, t2;

if (tm1.yr  < 1970  || 
    tm1.mo  < 1 ||  tm1.mo > 12 ||
    tm1.day < 1 || tm1.day > 31 ||
    tm1.hr  < 0 ||  tm1.hr > 23 ||
    tm1.mn  < 0 ||  tm1.mn > 59) {
    // fprintf(stderr,"TIMADD: input t-array has invalid entries ...\n");
    // fprintf(stderr,"TM1 %d %d %d %d %d %f\n",
    // tm1.yr,tm1.mo,tm1.day,tm1.hr,tm1.mn,tm1.sec);
    return(0);
}
if (tm2.yr  < 1970  || 
    tm2.mo  < 1 ||  tm2.mo > 12 ||
    tm2.day < 1 || tm2.day > 31 ||
    tm2.hr  < 0 ||  tm2.hr > 23 ||
    tm2.mn  < 0 ||  tm2.mn > 59) {
    return(0);
}

// fprintf(stdout,"TIMDIF: tm1 minute:second= %d:%f\n", tm1.mn,tm1.sec);
// fprintf(stdout,"TIMDIF: t1= %f t2= %f\n", t1,t2);
// fprintf(stdout,"TIMDIF: tm2 minute:second= %d:%f\n", tm2.mn,tm2.sec);

time2sec(tm1, &t1);
time2sec(tm2, &t2);

*ts = t1 - t2;
// fprintf(stdout,"TIMDIF: t1= %f t2= %f\n", t1,t2);
// fprintf(stdout,"TIMDIF: ts= %f\n", *ts);

return(1);
}
