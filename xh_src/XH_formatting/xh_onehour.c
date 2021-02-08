#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"		// XH   structures
#include "time.h"		// time structures

// Cuts a traces from origin time t0 to t0+3600.
// Pads with zeroes if necessary

main(argc,argv)
int argc;
char *argv[];
{

xhhed 	h;

// record starttime
xh_time  st;
xh_time  ot;

int 	i, ierr, j, k;
int     np;

int i_onehour;        // one hour worth of samples (dt)
int i0;

int still_reading_data = 1;
int use_this_record    = 1;
float seism[XH_NPTS];
float seism_cpy[XH_NPTS];
float dt;

float v1, v2, dvdt;
float diff;


char infile[80];
FILE *ifl, *ofl, *fopen();

int usage();

if(argc != 3) {
  ierr = usage();
  exit(ierr);
}
if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     exit(ierr);
}
if ((ofl = fopen(argv[2],"w")) == NULL) {
     ierr = usage();
     exit(ierr);
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

  // make a copy of seism
  for (k=0; k<h.ndata; k++)
       seism_cpy[k] = seism[k];

  // record start time
  st.yr  = h.tstart.yr;
  st.mo  = h.tstart.mo;
  st.day = h.tstart.day;
  st.hr  = h.tstart.hr;
  st.mn  = h.tstart.mn;
  st.sec = h.tstart.sec;
  // record origin time
  ot.yr  = h.ot.yr;
  ot.mo  = h.ot.mo;
  ot.day = h.ot.day;
  ot.hr  = h.ot.hr;
  ot.mn  = h.ot.mn;
  ot.sec = h.ot.sec;

  if (! timdif(ot, st, &diff)) {
      fprintf(stderr,"Error in timdif() ...\n");
      exit(-1);
  }
  if (diff >= 0.) {
    i0      = floor(diff/h.delta);
    dt      = diff-i0*h.delta;
  }
  if (diff < 0.) {
    i0      = floor(diff/h.delta);
    dt      = diff-i0*h.delta;
  }
  if (dt == h.delta) {
      fprintf(stderr,"Error in finding i0 ...\n");
      exit(-1);
  }

  i_onehour = (int) rintf(3600./h.delta);

 fprintf(stdout,"%-4s %-2s %-3s ndata= %d delta= %f diff= %8.2f i0= %d dt = %7.2f\n",
      h.stnm,h.netw,h.chan,h.ndata,h.delta,diff,i0,dt);

  if (diff >= 0.) {
    for (i=i0; i<i0+i_onehour; i++) {
       if ( i<h.ndata-2) {
         v1 = seism_cpy[i];
         v2 = seism_cpy[i+1];
         dvdt = (v2-v1)/h.delta;
         seism[i-i0] = seism_cpy[i] + dvdt*dt ;
       } else {
         seism[i-i0] = 0.;
       }
    }
  }
  if (diff < 0.) {
    i0 = -i0;
    for (i=0; i<i0; i++)
       seism[i] = 0.;
    for (i=i0; i<i_onehour; i++) {
       if ( i<h.ndata-2) {
         v1 = seism_cpy[i-i0];
         v2 = seism_cpy[i-i0+1];
         dvdt = (v2-v1)/h.delta;
         seism[i] = seism_cpy[i-i0] + dvdt*dt ;
       } else {
         seism[i] = 0.;
       }
    }
  }

  h.tstart.yr  = ot.yr;
  h.tstart.mo  = ot.mo;
  h.tstart.day = ot.day;
  h.tstart.hr  = ot.hr;
  h.tstart.mn  = ot.mn;
  h.tstart.sec = ot.sec;
  
  // reset pick times
  for(i=0;i<14;i++)
    h.tpcks[i] = h.tpcks[i]-diff;

  // new number of data points
  h.ndata = i_onehour;
  

  // WRITE XH header and data
  if (! xh_writehead(ofl,h))
    exit (-1);
  if (! xh_writedata(ofl,h,seism)) 
    exit (-1);
} // while

fclose (ifl);
fclose (ofl);
}

int usage()
        {
        fprintf(stderr,"Usage: xh_onehour in_XHfile out_XHfile\n");
        fprintf(stderr,"       Generates 1-hour long traces starting\n");
        fprintf(stderr,"       at the earthquake origin time\n");
        return(-1);
}
