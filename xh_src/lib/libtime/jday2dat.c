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
