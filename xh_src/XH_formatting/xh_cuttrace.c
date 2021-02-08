#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"		// XH   structures
#include "time.h"		// time structures

// Cut trace "T" seconds around pick
// with picknumber "np" (see "~/inc/xhhead.h")
// cut: [pick-t1,pick+t2]

main(argc,argv)
int argc;
char *argv[];
{

xhhed 	h;

// record starttime
xh_time  ts;
xh_time  ts_new;

int 	i, ierr, j;
int     np;
int     n;
int     ib;

int still_reading_data = 1;
int use_this_record    = 1;
float seism[XH_NPTS];
float seism_cpy[XH_NPTS];
float t1, t2;
float time1, time2;
float dt, dvdt, v1, v2;
float total;
float tb_time;

char infile[80];
FILE *ifl, *ofl, *fopen();

int usage();

if(argc != 8) usage("");
if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage(argv[1]);
     return(ierr);
}
if ((ofl = fopen(argv[2],"w")) == NULL) {
     ierr = usage(argv[2]);
     return(ierr);
}
if (strncmp(argv[3],"-n",2) != 0) {
     ierr = usage();
     exit(ierr);
} else {
     np = atoi(argv[4]);
}
if (strncmp(argv[5],"-t",2) != 0) {
     ierr = usage();
     exit(ierr);
} else {
    sscanf(argv[6],"%f", &time1);
    sscanf(argv[7],"%f", &time2);
}

while (still_reading_data) {
  if   (! xh_readhead(ifl,&h)) {
    still_reading_data = 0;
    exit(0);
  } else {
    if (! xh_readdata(ifl,h,seism)) {
      still_reading_data = 0;
      exit(0);
    }
  }
  // check header
  if (! xh_checkheader(h) )
    exit(-1);
  use_this_record = 1;

  // make a copy of seism
  for (i=0; i<h.ndata; i++)
    seism_cpy[i] = seism[i];
  // start time
  ts.yr  = h.tstart.yr;
  ts.mo  = h.tstart.mo;
  ts.day = h.tstart.day;
  ts.hr  = h.tstart.hr;
  ts.mn  = h.tstart.mn;
  ts.sec = h.tstart.sec;

  // begin and end time of new trace
  t1 = h.tpcks[np]-time1;
  t2 = h.tpcks[np]+time2;
  if (t1 < 0. || t2 > (h.ndata*h.delta) ) {
      fprintf(stderr," Record -%s- -%s- too shott for window ...\n", h.stnm,h.chan);
      use_this_record = 0;
  }

  if ( use_this_record ) {
     ib = floor(t1/h.delta);
     dt = t1-ib*h.delta;
     n  = (int) rintf((t2-t1)/h.delta) + 1;
     for (i=ib; i<ib+n; i++) {
       if ( i<h.ndata-2) {
          v1 = seism_cpy[i];
          v2 = seism_cpy[i+1];
          dvdt = (v2-v1)/h.delta;
          seism[i-ib] = seism_cpy[i] + dvdt*dt ;
        } else {
          seism[i-ib] = 0.;
        }
     }
     // reset pick times
     h.tpcks[np] = h.tpcks[np]-t1;
     // for(i=0;i<14;i++)
     //   h.tpcks[i] = h.tpcks[i]-t1;
     // new number of data points
     h.ndata = n;
 
     if (! timadd(ts,t1,&ts_new)) {
       fprintf(stderr,"Error in timadd ...\n");
       exit(-1);
     }
     h.tstart.yr  = ts_new.yr;
     h.tstart.mo  = ts_new.mo;
     h.tstart.day = ts_new.day;
     h.tstart.hr  = ts_new.hr;
     h.tstart.mn  = ts_new.mn;
     h.tstart.sec = ts_new.sec;
     // WRITE XH header and data
     fprintf(stdout,"%-4s %-2s %-3s  Pick= %8.2f\n", h.netw, h.stnm, h.chan, h.tpcks[np]);
     if (! xh_writehead(ofl,h))
       exit (-1);
     if (! xh_writedata(ofl,h,seism)) 
       exit (-1);
  }
} // while

fclose (ifl);
fclose (ofl);
}

int usage(flnm)
char *flnm;
        {
        fprintf(stderr,"Usage: xh_cuttrace in_XHfile out_XHfile -n NP -t t1 t2\n");
        return(-1);
}
