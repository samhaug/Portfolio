#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>

#include <math.h>
#include "xhhead.h"	/* XH format structures */
#include "time.h"

int xh_copytime_ts(tm,xh)
xh_time *tm;
xhhed xh;
{
xh_time t1;
t1.yr  = xh.tstart.yr;
t1.mo  = xh.tstart.mo;
t1.day = xh.tstart.day;
t1.hr  = xh.tstart.hr;
t1.mn  = xh.tstart.mn;
t1.sec = xh.tstart.sec;
*tm = t1;
return(1);
}
