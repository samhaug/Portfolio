// Determines the difference in between the start time
// and the origin time in header h;

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <sys/file.h>

#include "xhhead.h"
#include "time.h"

int xh_TsT0_diff(h,tdiff)
xhhed h;
float *tdiff;
{

xh_time tm1, tm2;
double   t1, t2;

tm1.yr  = h.tstart.yr;
tm1.mo  = h.tstart.mo;
tm1.day = h.tstart.day;
tm1.hr  = h.tstart.hr;
tm1.mn  = h.tstart.mn;
tm1.sec = h.tstart.sec;

tm2.yr  = h.ot.yr;
tm2.mo  = h.ot.mo;
tm2.day = h.ot.day;
tm2.hr  = h.ot.hr;
tm2.mn  = h.ot.mn;
tm2.sec = h.ot.sec;

// fprintf(stdout,"xh_TsT0_diff() tm1= %d %d %d %d %d %f\n", tm1.yr,tm1.mo,tm1.day,tm1.hr,tm1.mn,tm1.sec);
// fprintf(stdout,"xh_TsT0_diff() tm2= %d %d %d %d %d %f\n", tm2.yr,tm2.mo,tm2.day,tm2.hr,tm2.mn,tm2.sec);


time2sec(tm1,&t1);
time2sec(tm2,&t2);

*tdiff = t1-t2;

return(1);
}
