//
// excit_2xh - Turns XY seismograms from EXCIT_M into XH 
//
// Assuming that the synthetics are in SYNT, and that
// they have been generated using the info in DATA/RECORDHEADERS
// Mostly adapted to work on PREM synthetics for Ling.
//



#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <malloc.h>
#include "xhhead.h"
#include "time.h"

//------------------------------------------------------------------------
// This is silly coding ... sorry
// The long-period EXCIT_M synthetics are expected to have 4096 samples!!!
#define NSYNT 409600
//------------------------------------------------------------------------

main( argc, argv )
int   argc;
char       *argv[];
{
    float     data[XH_NPTS], synt[XH_NPTS];
    float     trace_100sps[NSYNT];
    float     trace_100sps_cpy[NSYNT];
    float     tstart;
    float     cmpaz, cmpinc;
    float     begint, cmt_time_shift;
    int       sec, msec, jday;

    int       index = 0;
    int       still_reading_data = 1;
    int	      ierr;
    int       i_start;
    int       i,j,k;
    int       useful;

    xhhed     h;
    xh_time   otime, stime;

    char      excit_file[80];
    char      synxy_file[80];
    char      xh_file[80];
    char      xh_data[80];
    char      ss[130];
    FILE     *ascfl, *xhfl, *solfl, *fopen();

if (argc != 4) {
  ierr = usage();
  exit(ierr);
}

// EXCIT ascii file
if ((ascfl=fopen(argv[1],"r")) == NULL) {
     ierr=usage();
     exit(-1);
}
// XH file
if ((xhfl=fopen(argv[2],"w")) == NULL) {
     ierr=usage();
     exit(-1);
}
// SOL file
if ((solfl=fopen(argv[3],"r")) == NULL) {
     ierr=usage();
     exit(-1);
}

fprintf(stdout,"Working on --%s--\n", argv[1]);

     if (! xh_setdefaults(&h)) {
        fprintf(stderr,"Error xh_readsac() ...\n");
        exit(-1);
     }
     // Line 1
     fgets(ss,130,ascfl);
     sscanf(ss,"%f %f %f %f %d", &begint,&h.delta,&otime,&cmt_time_shift,&h.ndata);
     // Line 2
     fgets(ss,130,ascfl);
     sscanf(ss,"%f %f %f %f %f %f", &h.slat,&h.slon,&h.elev,&h.elat,&h.elon,&h.edep);
     // Line 3
     fgets(ss,130,ascfl);
     sscanf(ss,"%d %d %d %d %d %d", &h.tstart.yr,&jday,&h.tstart.hr,&h.tstart.mn,&sec,&msec);
     k=jday2dat(h.tstart.yr, jday, &h.tstart.mo, &h.tstart.day);
//   fprintf(stdout,"c7= --%04d/%02/%02d--\n",h.tstart.yr,h.tstart.mo,h.tstart.day);
     h.tstart.sec = sec*1.0 + msec/1000.;
     /* Begin time added to fix FK synthetics ....*/
     h.tstart.sec = h.tstart.sec + begint;

//   fprintf(stdout,"tstart= %d/%d/%d %02d:%02d:%5.2f\n",
//     h.tstart.yr,h.tstart.mo,h.tstart.day,h.tstart.hr,h.tstart.mn,h.tstart.sec);

     h.ot.yr = h.tstart.yr;
     h.ot.mo = h.tstart.mo;
     h.ot.day = h.tstart.day;
     h.ot.hr = h.tstart.hr;
     h.ot.mn = h.tstart.mn;
     h.ot.sec = h.tstart.sec;
     fgets(ss,130,ascfl);
     sscanf(ss,"%s %s %s", h.stnm,h.netw,h.chan);
//   fprintf(stdout,"-%s-%s-%s-\n", h.stnm,h.netw,h.chan);
     fgets(ss,130,ascfl);
     sscanf(ss,"%f %f", &cmpaz, &cmpinc);

     // reading the synthetics
     for (i=0; i<h.ndata; i++) 
       fscanf(ascfl,"%f", &synt[i]);

     // source parameters
     fgets(ss,130,solfl);
     fgets(ss,130,solfl);
     fgets(ss,130,solfl);
     fgets(ss,130,solfl);
     fgets(ss,130,solfl);
     sscanf(ss,"%*s %f", &h.elat);
     fgets(ss,130,solfl);
     sscanf(ss,"%*s %f", &h.elon);
     fgets(ss,130,solfl);
     sscanf(ss,"%*s %f", &h.edep);

     strcpy(h.wavf,"dis");
     if( strncmp("LHT",h.chan,3) == 0) h.chid = 5;
     if( strncmp("LHL",h.chan,3) == 0) h.chid = 4;
     if( strncmp("LHR",h.chan,3) == 0) h.chid = 4;
     if( strncmp("LHZ",h.chan,3) == 0) h.chid = 1;

     // WRITE XH header and data
//   fprintf(stdout,"Writing SYN:  --%s--%s--%s--\n", h.netw,h.stnm,h.chan);
     if (! xh_writehead(xhfl,h))
       exit (-1);
     if (! xh_writedata(xhfl,h,synt))
       exit (-1);
        
    
exit( 0 );
} 

int usage()
{
fprintf(stderr,"Usage: excitM3_2xh dat_XH out_XH cmt_SOL\n");
return(-1);
}
