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

        if (*jday > 366) return(0);
        return(1);
}
