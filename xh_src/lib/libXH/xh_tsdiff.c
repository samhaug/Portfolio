/* Determines the difference in start time
   in headers h1 and h2;
*/

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <sys/file.h>

#include "xhhead.h"
#include "time.h"

int xh_tsdiff(h1,h2,tdiff)
xhhed h1, h2;
float *tdiff;
{

xh_time tm1, tm2;
double   t1, t2;

tm1.yr  = h1.tstart.yr;
tm1.mo  = h1.tstart.mo;
tm1.day = h1.tstart.day;
tm1.hr  = h1.tstart.hr;
tm1.mn  = h1.tstart.mn;
tm1.sec = h1.tstart.sec;

tm2.yr  = h2.tstart.yr;
tm2.mo  = h2.tstart.mo;
tm2.day = h2.tstart.day;
tm2.hr  = h2.tstart.hr;
tm2.mn  = h2.tstart.mn;
tm2.sec = h2.tstart.sec;

time2sec(tm1,&t1);
time2sec(tm2,&t2);

*tdiff = t1-t2;

return(1);
}
