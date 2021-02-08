//
// excit_lpsyn - Turns XY seismograms from EXCIT_M into XH 
//
// Applies only to the synthetics in Research/LP_synthetics


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <malloc.h>
#include "xhhead.h"
#include "time.h"

//------------------------------------------------------------------------
// This is silly coding ... sorry
// The long-period EXCIT_M synthetics are expected to have 8192 samples!!!
#define NSYNT 819200
//------------------------------------------------------------------------

main( argc, argv )
int   argc;
char       *argv[];
{
    float     data[XH_NPTS], synt[XH_NPTS];
    float     trace_100sps[NSYNT];
    float     trace_100sps_cpy[NSYNT];
    float     tstart;
    float     v1, v2, dv;
    float     pi2;
    float     taper;

    float     begint, cmt_time_shift;
    int       sec, msec, jday;

    int       index = 0;
    int       still_reading_data = 1;
    int	      ierr;
    int       i_trace=0;
    int       i_start;
    int       i,j,k;
    int       useful;

    xhhed     h;
    xh_time   otime, stime;

    char      ss[130];
    FILE     *exfl, *xhfl, *fopen();

pi2 = atan(1.)*2.;
fprintf(stdout,"b0 argc= %d\n", argc);
if (argc != 3) {
  ierr = usage();
  exit(ierr);
}

// EXCIT INPUT FILE
if ((exfl=fopen(argv[1],"r")) == NULL) {
     ierr=usage();
     exit(-1);
}

// XH OUTPUT FILE
if ((xhfl=fopen(argv[2],"w")) == NULL) {
     ierr=usage();
     exit(-1);
}
if (! xh_setdefaults(&h)) {
    fprintf(stderr,"Error xh_readsac() ...\n");
    exit(-1);
}

// Line 1
fgets(ss,130,exfl);
sscanf(ss,"%f %f %f %f %d",
     &begint,&h.delta,&otime,&cmt_time_shift,&h.ndata);
// Line 2
fgets(ss,130,exfl);
sscanf(ss,"%f %f %f %f %f %f",
     &h.slat,&h.slon,&h.elev,&h.elat,&h.elon,&h.edep);
// Line 3
fgets(ss,130,exfl);
sscanf(ss,"%d %d %d %d %d %d",
     &h.tstart.yr,&jday,&h.tstart.hr,&h.tstart.mn,&sec,&msec);
fprintf(stdout,"c6= --%d-%d--\n",sec,msec);
k=jday2dat(h.tstart.yr, jday, &h.tstart.mo, &h.tstart.day);
fprintf(stdout,"c7= --%04d/%02/%02d--\n",h.tstart.yr,h.tstart.mo,h.tstart.day);
h.tstart.sec = sec*1.0 + msec/1000.;
/* Begin time added to fix FK synthetics ....*/
 h.tstart.sec = h.tstart.sec + begint;

fprintf(stdout,"tstart= %d/%d/%d %02d:%02d:%5.2f\n", h.tstart.yr,h.tstart.mo,h.tstart.day,h.tstart.hr,h.tstart.mn,h.tstart.sec);

fgets(ss,130,exfl);
sscanf(ss,"%s %s %s",
      h.stnm,h.netw,h.chan);
// dummy
fgets(ss,130,exfl);

// reading the synthetics
fprintf(stdout,"-%s-%s-%s-\n", h.stnm,h.netw,h.chan);
for (i=0; i<h.ndata; i++) {
  fscanf(exfl,"%f", &synt[i]);
}


// z-comp
if (        strncmp(h.chan,"LHZ",3) == 0 ) { 
   h.chid = 1; 
     // r-comp
} else if ( strncmp(h.chan,"LHL",3) == 0 ) { 
   h.chid = 4; 
     // t-comp
} else if ( strncmp(h.chan,"LHT",3) == 0 ) { 
   h.chid = 5; 
} else {
   fprintf(stderr,"Unknown channel --%s--\n", h.chan);
   exit(-1);
}

// Tapering the first and last 50 seconds of the synthetics to zero
j =  (int) rintf( 50./h.delta );
for (i=0; i<j; i++) {
   taper = i*1./j*pi2;
   taper = sin(taper);
   taper = taper*taper;
   synt[i] = synt[i]*taper;
}
for (i=h.ndata-j; i<h.ndata; i++) {
   taper = (h.ndata-i-1)*1./j*pi2;
   taper = sin(taper);
   taper = taper*taper;
   synt[i] = synt[i]*taper;
}

// The EXCIT_M synthetics must have 8192 samples!!!!
if (h.ndata != NSYNT/100) {
   fprintf(stderr,"Number of samples of EXCIT_M synthetics is not 8192 ...\n");
   exit(-1);
}
// Resampling the synthetics by a factor of 100
for (i=0; i<h.ndata; i++) {
   v1 = synt[i];
   v2 = synt[i+1];
   dv = (v2-v1)/100;
   for (j=0; j<100; j++) {
     k = i*100 + j;
     trace_100sps[k] = v1 + j*dv;
     // if (i_trace==1) fprintf(stdout,"%f %e\n", k/100., trace_100sps[k]);
   }
}
i_start =  0;
// Shifting the synthetics by TSTART
for (i=0; i<NSYNT; i++)
   trace_100sps_cpy[i] = 0.;
for (i=0; i<NSYNT; i++) {
   j = i - i_start;
   if (j>=0 && j<NSYNT)
      trace_100sps_cpy[j] = trace_100sps[i];
   // if (i_trace==1) fprintf(stdout,"%i %e\n", i, trace_100sps_cpy[i]);
}
// Copying some header variables ....
h.tstart = h.tstart;
h.ot     = h.ot;
h.elat   = h.elat;
h.elon   = h.elon;
h.edep   = h.edep;
h.slat   = h.slat;
h.slon   = h.slon;
h.chid   = h.chid;
// strcpy(h.netw,h.netw);
// strcpy(h.stnm,h.stnm);
strcpy(h.chan,h.chan);
strcpy(h.wavf,"dis");

// Decimating the synthetics by a factor of 100
for (i=0; i<h.ndata; i++) {
     synt[i] = 0.;
     k = i*100;
     synt[i] = trace_100sps_cpy[k];
     //if (i_trace==1) fprintf(stdout,"%i %e\n", i, synt[i]);
}
// WRITE XH header and data
fprintf(stdout,"Writing SYN:  --%s--%s--%s--\n", h.netw,h.stnm,h.chan);
if (! xh_writehead(xhfl,h))
  exit (-1);
if (! xh_writedata(xhfl,h,synt))
  exit (-1);


exit( 0 );
} 

int usage()
{
fprintf(stderr,"Usage: xh_lpsyn in_EXC out_XH\n");
return(-1);
}
