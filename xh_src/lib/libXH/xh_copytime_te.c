#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>

#include <math.h>
#include "xhhead.h"	/* XH format structures */
#include "time.h"	/* TIME format structures */

int xh_copytime_te(tm,xh)
xhhed xh;
xh_time *tm;
{
xh_time t1;
double time;
                                                                                                                                    
                                                                                                                                    
t1.yr  = xh.tstart.yr;
t1.mo  = xh.tstart.mo;
t1.day = xh.tstart.day;
t1.hr  = xh.tstart.hr;
t1.mn  = xh.tstart.mn;
t1.sec = xh.tstart.sec;
                                                                                                                                    
time2sec(t1,&time);
time = time + (double) xh.ndata*xh.delta;
sec2time(&t1,time);
                                                                                                                                    
*tm = t1;
return(1);
}

