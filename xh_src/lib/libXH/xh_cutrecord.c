#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>

#include <math.h>
#include "xhhead.h"	/* XH format structures */
#include "time.h"


// Checks the header of XH

int xh_cutrecord(begtime,endtime,h,rcd,ofl)
xh_time begtime;
xh_time endtime;
xhhed h;
float rcd[];
FILE *ofl;
{

xh_time tt;
xhhed   h1;
float time;
int i, ib;
int nsamp;
int timdif();

h1 = h;
// begin time from record
tt.yr  = h1.tstart.yr;
tt.mo  = h1.tstart.mo;
tt.day = h1.tstart.day;
tt.hr  = h1.tstart.hr;
tt.mn  = h1.tstart.mn;
tt.sec = h1.tstart.sec;

//number of samples in new record
if (! timdif(endtime,begtime,&time))
  return(0);
nsamp = lrint(time/h1.delta)+1;
// "time" = (begtime - begtime_of_record) in seconds 
if (! timdif(begtime,tt,&time))
  return(0);
ib = lrint(time/h1.delta);
for(i=0;i<nsamp;i++) {
  rcd[i]=rcd[i+ib];
}

// set new begin time
h1.tstart.yr  = begtime.yr;
h1.tstart.mo  = begtime.mo;
h1.tstart.day = begtime.day;
h1.tstart.hr  = begtime.hr;
h1.tstart.mn  = begtime.mn;
h1.tstart.sec = begtime.sec;
// set new number of samples
h1.ndata = nsamp;
// reset IASP91 traveltimes
for(i=0;i<1;i++) {
 if (h1.tpcks[i] != -999.) h1.tpcks[i]=h1.tpcks[i]-time; 
}
if (h1.ndata <= 0) {
  fprintf(stdout,"xh_cutrecord() %s/%s/%s NSAMP= %d\n",h1.netw,h1.stnm,h1.chan,h1.ndata);
} else {
// writing new header and windowed data
  if (! xh_writehead(ofl,h1))
    return(0);
  if (! xh_writedata(ofl,h1,rcd))
    return(0);
}

return(1);
}
