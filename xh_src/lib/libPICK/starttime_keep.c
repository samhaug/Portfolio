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


fprintf(stdout,"In STARTTIME: Year1= %d Year2= %d\n", h.tstart.yr,h.ot.yr);
if (h.tstart.yr != h.ot.yr) {
   fprintf(stderr,"In TIMEDIFF: Year1 is not equal to Year2\n");
   return(0);
}
fprintf(stdout,"In STARTTIME: Year1= %d Year2= %d\n", h.tstart.yr,h.ot.yr);

fprintf(stdout,"%d/%d/%f\n", h.tstart.hr,h.tstart.mn,h.tstart.sec);

jday1 = julian(h.tstart.yr,h.tstart.mo,h.tstart.day);
jday2 = julian(h.ot.yr,h.ot.mo,h.ot.day);
fprintf(stdout,"In STARTTIME: jday1= %d\n", jday1);
fprintf(stdout,"In STARTTIME: jday2= %d\n", jday2);

td =        (jday1 - jday2)*24.*3600.;
fprintf(stdout,"In STARTTIME: a1 sec= %f\n", td);
fprintf(stdout,"%d/%d/%f\n", h.tstart.hr,h.tstart.mn,h.tstart.sec);
td = td + (h.tstart.hr-h.ot.hr)*3600.;
fprintf(stdout,"In STARTTIME: a2b sec= %f\n", td);
fprintf(stdout,"%d/%d/%f\n", h.tstart.hr,h.tstart.mn,h.tstart.sec);
fprintf(stdout,"In STARTTIME: a3a sec= %f\n", td);
td = td + (h.tstart.mn-h.ot.mn)*60.;
fprintf(stdout,"%d/%d/%f\n", h.tstart.hr,h.tstart.mn,h.tstart.sec);
fprintf(stdout,"In STARTTIME: a4 sec= %f\n", td);
td = td + (h.tstart.sec-h.ot.sec)*1.;
fprintf(stdout,"%d/%d/%f\n", h.tstart.hr,h.tstart.mn,h.tstart.sec);
fprintf(stdout,"In STARTTIME: a5 sec= %f\n", td);
fprintf(stdout,"%d/%d/%f\n", h.tstart.hr,h.tstart.mn,h.tstart.sec);

*ts = td;

return(1);
}
