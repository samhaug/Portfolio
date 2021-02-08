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

/* Converting SECONDS SINCE 1970 to TIME_ARRAY
(see xh_time of /work/jeroen/inc/time.h):

WORKS ONLY FOR DATES AFTER 1970 !!!
*/


/* ---------------------------------------------- */
int sec2time(tm, tsec)
xh_time *tm;
double tsec;
{

int i, k;
int i_year, i_month, i_day, i_hour, i_min;
int done=0;
double t;
double t0;
double t1;

double sec_in_year  = 365.*24.*3600.;
double sec_in_day   =      24.*3600.;
double sec_in_month =             0.;

done = 0;

t0 = tsec;
i_year = 1970;
while( ! done) {
   t1                     = t0 - sec_in_year;
   if (isleap(i_year)) {
     t1 = t1 - sec_in_day;
   }
   if(t1 < 0) {
       done = 1;
   } else {
       t0 = t1;
       i_year++;
   }
}

/* We found the year; now continue on with the month */
k = isleap(i_year);
done = 0;
for (i_month=1; i_month<=12; i_month++) {
   sec_in_month = dim[k][i_month]*24*3600.;
   t1 = t0 - sec_in_month;
   if(t1 < 0) {
       break;
   } else {
       t0 = t1;
   }
}

/* We found the month; now continue on with the day */
for (i_day=1; i_day<=31; i_day++) {
   t1 = t0 - sec_in_day;
   if(t1 < 0) {
       break;
   } else {
       t0 = t1;
   }
}

/* We found the day; now continue on with the hour */
for (i_hour=0; i_hour<=23; i_hour++) {
   t1 = t0 - 3600.;
   if(t1 < 0) {
       break;
   } else {
       t0 = t1;
   }
}

/* We found the day; now continue on with the min */
for (i_min=0; i_min<=59; i_min++) {
   t1 = t0 - 60.;
   if(t1 < 0) {
       break;
   } else {
       t0 = t1;
   }
}

tm->yr  = i_year;
tm->mo  = i_month;
tm->day = i_day;
tm->hr  = i_hour;
tm->mn  = i_min;
tm->sec = t0;

return(1);
}
