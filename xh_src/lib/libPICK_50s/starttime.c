#include <math.h>
#include <stdio.h>
#include <string.h>
#include "xhhead.h"

int starttime(h, ts)
   xhhed    h;
   float   *ts;
{

int   jday1, jday2;
float td;


if (h.tstart.yr != h.ot.yr) {
   fprintf(stderr,"In TIMEDIFF: Year1 is not equal to Year2\n");
   return(0);
}
// fprintf(stdout,"%d/%d/%f\n", h.tstart.hr,h.tstart.mn,h.tstart.sec);

jday1 = julian(h.tstart.yr,h.tstart.mo,h.tstart.day);
jday2 = julian(h.ot.yr,h.ot.mo,h.ot.day);

td =      (jday1 - jday2)*24.*3600.;
td = td + (h.tstart.hr-h.ot.hr)*3600.;
td = td + (h.tstart.mn-h.ot.mn)*60.;
td = td + (h.tstart.sec-h.ot.sec)*1.;

// fprintf(stdout,"%d/%d/%f\n", h.tstart.hr,h.tstart.mn,h.tstart.sec);
// fprintf(stdout,"In STARTTIME: a5 sec= %f\n", td);
// fprintf(stdout,"%d/%d/%f\n", h.tstart.hr,h.tstart.mn,h.tstart.sec);

*ts = td;

return(1);
}
