#include <stdio.h>
#include <stdlib.h>
#include <math.h>

/* Calendar computations (old and new-style) */

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

/*-----------------------------------------------------------*/

/* Recognize leap years */

int isleap(yr)
int     yr;
{
        int     l;

        if (yr < 0) yr++;
        l = (yr%4 == 0);
        l = l && (yr%100 != 0 || yr%400 == 0);
        return l;
}

/* Compute Julian Day number from calendar date */

int dat2jday(yr, mo, day, jday)
int     yr, mo, day, *jday;
{
	int k=0, l, i;

        if (yr              < 0) return(0);
        if (mo > 12  || mo  < 0) return(0);
        if (day > 31 || day < 0) return(0);
        k=isleap(yr);

        *jday = eom[k][mo-1]; 
        *jday = *jday + day;

        if (*jday < 366) {
          return(1);
	} else {
	  return(0);
	}
}

/* Compute Calendar Date from Julian Day number */

int jday2dat(yr, jday, mo, day)
int     yr, *mo, *day ,jday;    /* Year, month, day                     */
{
	int  k=0, l, i;

        if (yr      <   0 ) return(0);
        if (jday    > 366 ) return(0);

        k=isleap(yr);

	for(i=1;i<=12;i++)  
          if (jday <= eom[k][i]) break;
        *mo = i;
        *day = jday - eom[k][i-1];

	if (*mo <= 12 && *day <= 31) {
          return(1);
	} else {
	  return(0);
        }
}

/* Converting the TIME_ARRAY
(see xh_time of /work/jeroen/inc/time.h):
to amount in seconds since 1970

WORKS ONLY FOR DATES AFTER 1970 !!!

*/

int time2sec(yr, mo, day, hr, mn, sec, ts)
int yr, mo, day, hr, mn;
float sec; 
float *ts;

{
int i, k;
int numly = 0;

if (yr  < 1970)          return(0);
if (mo  < 1 ||  mo > 12) return(0);
if (day < 1 || day > 31) return(0);
if (hr  < 0 ||  hr > 23) return(0);
if (mn  < 0 ||  hr > 59) return(0);


*ts = 0.;

for (i=1970; i<yr;i++) {
   *ts    = *ts + 365*24*3600.;
   if (isleap(i) == 1) {
      numly++;
      *ts = *ts +     24*3600.;
   }
}

k = isleap(yr);
*ts = *ts + eom[k][mo-1]*24*3600.;

for (i=1; i<day;i++) {
   *ts = *ts + 24*3600.;
}
*ts = *ts + hr*3600. + mn*60. + sec;

return(1);
}

/* ---------------------------------------------- */
int sec2time(yr, mo, day, hr, mn, sec, tsec)
int *yr, *mo, *day, *hr, *mn;
float *sec;
float tsec;
{

int i, k;
int i_year, i_month, i_day, i_hour, i_min;;
int done=0;
float t;
float t0, t1;

float sec_in_year  = 365.*24.*3600.;
float sec_in_day   =      24.*3600.;
float sec_in_month =             0.;

done = 0;

t0 = tsec;
/* fprintf(stdout,"t0= %f\n", t0); */
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
/* fprintf(stdout,"year= %d\n", i_year); */
/* fprintf(stdout,"Seconds left over: %f\n", t0); */

/* We found the year; now continue on with the month */
k = isleap(i_year);
done = 0;
for (i_month=1; i_month<=12; i_month++) {
   sec_in_month = dim[k][i_month]*24*3600.;
   t1 = t0 - sec_in_month;
   /* fprintf(stdout,"secmonth= %f t1= %f\n",sec_in_month, t1); */
   if(t1 < 0) {
       break;
   } else {
       t0 = t1;
       /* fprintf(stdout,"month= %d t0= %f t1= %f\n", i_month, t0, t1); */
   }
}
/* fprintf(stdout,"month= %d\n", i_month); */
/* fprintf(stdout,"Seconds left over: %f\n", t0); */

/* We found the month; now continue on with the day */
for (i_day=1; i_day<=31; i_day++) {
   t1 = t0 - sec_in_day;
   /* fprintf(stdout,"t1= %f\n", t1); */
   if(t1 < 0) {
       break;
   } else {
       t0 = t1;
       /* fprintf(stdout,"day= %d\n", i_day); */
       /* fprintf(stdout,"t0= %f\n", t0); */
   }
}
/* fprintf(stdout,"day= %d\n", i_day); */
/* fprintf(stdout,"Seconds left over: %f\n", t0); */

/* We found the day; now continue on with the hour */
for (i_hour=0; i_hour<=23; i_hour++) {
   t1 = t0 - 3600.;
   /* fprintf(stdout,"t1= %f\n", t1); */
   if(t1 < 0) {
       break;
   } else {
       t0 = t1;
       /* fprintf(stdout,"hour= %d\n", i_hour); */
       /* fprintf(stdout,"t0= %f\n", t0); */
   }
}
/* fprintf(stdout,"hour= %d\n", i_hour); */
/* fprintf(stdout,"Seconds left over: %f\n", t0); */

/* We found the day; now continue on with the min */
for (i_min=0; i_min<=59; i_min++) {
   t1 = t0 - 60.;
   /* fprintf(stdout,"Is t1= %f negative?\n", t1); */
   if(t1 < 0) {
       break;
   } else {
       t0 = t1;
       /* fprintf(stdout,"Not negative!\n"); */
       /* fprintf(stdout,"min= %d\n", i_min); */
       /* fprintf(stdout,"t0= %f\n", t0); */
   }
}
/* fprintf(stdout,"min= %d\n", i_min); */
/* fprintf(stdout,"Seconds left over: %f\n", t0); */

*yr  = i_year;
*mo  = i_month;
*day = i_day;
*hr  = i_hour;
*mn  = i_min;
*sec = t0;

/* fprintf(stdout,"yr= %d\n", *yr); */
/* fprintf(stdout,"mo= %d\n", *mo); */

return(1);
}
