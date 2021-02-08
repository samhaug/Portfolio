//
// excit_2xh - Turns SAC seismograms from EXCIT_M into XH 
//
// Assuming that the synthetics are in SYNT, and that
// they have been generated using the info in DATA/RECORDHEADERS
//
// J. Ritsema, Univ. Michigan, October 2006.


#include <stdio.h>
#include <string.h>
#include <math.h>
#include <malloc.h>
#include "xhhead.h"
#include "time.h"

//------------------------------------------------------------------------
// This is silly coding ... sorry
// Hardwired for now!!!!!!!
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
    float     v1, v2, dv;
    float     pi2;
    float     taper;

    int       index = 0;
    int       still_reading_data = 1;
    int	      ierr;
    int       i_trace=0;
    int       i_start;
    int       i,j,k;
    int       useful;

    xhhed     h_dat, h_syn;
    xh_time   otime, stime;

    char      excit_file[80];
    char      synsac_file[80];
    char      xh_file[80];
    char      xh_data[80];
    char      ss[130];
    FILE     *xhdfl, *xhsfl, *fopen();

pi2 = atan(1.)*2.;
if (argc != 3) {
  ierr = usage();
  exit(ierr);
}

// XH data file
if ((xhdfl=fopen(argv[1],"r")) == NULL) {
     ierr=usage();
     exit(-1);
}
// XH synthetics
if ((xhsfl=fopen(argv[2],"w")) == NULL) {
     ierr=usage();
     exit(-1);
}


// Loop over traces in xhdfl
while (still_reading_data) {
  if    (! xh_readhead(xhdfl,&h_dat)) {
     still_reading_data=0;
     break;
  } else {
     if (! xh_readdata(xhdfl,h_dat,data)) {
       still_reading_data=0;
       exit(-1);
     }
     // check header
     if (! xh_checkheader(h_dat) )
       exit(-1);
     i_trace++;

     // z-comp
     if        ( strncmp(h_dat.chan,"LHZ",3)==0 || h_dat.chid==1 ) { 
       if      (h_dat.stnm[3] == ' ') {
          sprintf(synsac_file,"SYNT/%s.%.3s.LHZ.SAC", h_dat.netw,h_dat.stnm);
       } else if (h_dat.stnm[4] == ' ') {
          sprintf(synsac_file,"SYNT/%s.%.4s.LHZ.SAC", h_dat.netw,h_dat.stnm);
       } else {
          sprintf(synsac_file,"SYNT/%s.%.5s.LHZ.SAC", h_dat.netw,h_dat.stnm);
       }
     // r-comp
     } else if ( strncmp(h_dat.chan,"LHR",3)==0 || h_dat.chid==4 ) { 
       if      (h_dat.stnm[3] == ' ') {
          sprintf(synsac_file,"SYNT/%s.%.3s.LHL.SAC", h_dat.netw,h_dat.stnm);
       } else if (h_dat.stnm[4] == ' ') {
          sprintf(synsac_file,"SYNT/%s.%.4s.LHL.SAC", h_dat.netw,h_dat.stnm);
       } else {
          sprintf(synsac_file,"SYNT/%s.%.5s.LHL.SAC", h_dat.netw,h_dat.stnm);
       }
     // t-comp
     } else if ( strncmp(h_dat.chan,"LHT",3)==0 || h_dat.chid==5 ) { 
       if      (h_dat.stnm[3] == ' ') {
          sprintf(synsac_file,"SYNT/%s.%.3s.LHT.SAC", h_dat.netw,h_dat.stnm);
       } else if (h_dat.stnm[4] == ' ') {
          sprintf(synsac_file,"SYNT/%s.%.4s.LHT.SAC", h_dat.netw,h_dat.stnm);
       } else {
          sprintf(synsac_file,"SYNT/%s.%.5s.LHT.SAC", h_dat.netw,h_dat.stnm);
       }
     } else {
       exit(-1);
     }
      fprintf(stdout,"Working on --%s--%s--%s--\n", h_dat.netw,h_dat.stnm,h_dat.chan);
      fprintf(stdout,"--%s--\n",synsac_file);


     fprintf(stdout,"A0 --%s--%s--%s--\n", h_dat.netw,h_dat.stnm,h_dat.chan);
     if (! xh_readsac(&h_syn,synt,synsac_file,&useful)) {
        fprintf(stderr,"Error xh_readsac() ...\n");
        exit(-1);
     }
     fprintf(stdout,"A1 --%s--%s--%s--\n", h_dat.netw,h_dat.stnm,h_dat.chan);
     // fprintf(stdout,"AFTER READSAC --%s--%s--%s--\n", h_syn.netw,h_syn.stnm,h_syn.chan);
     // Tapering the first and last 50 seconds of the synthetics to zero
     j = lrint( 50./h_syn.delta );
     for (i=0; i<j; i++) {
        taper = i*1./j*pi2;
        taper = sin(taper);
        taper = taper*taper;
        synt[i] = synt[i]*taper;
     }
     for (i=h_syn.ndata-j; i<h_syn.ndata; i++) {
        taper = (h_syn.ndata-i-1)*1./j*pi2;
        taper = sin(taper);
        taper = taper*taper;
        synt[i] = synt[i]*taper;
     }

     // The EXCIT_M synthetics must have 4096 samples!!!!
     if (h_syn.ndata != NSYNT/100) {
        fprintf(stderr,"Number of samples of EXCIT_M synthetics is not 4096 ...\n");
        exit(-1);
     }
     // Resampling the synthetics by a factor of 100
     for (i=0; i<h_syn.ndata; i++) {
        v1 = synt[i];
        v2 = synt[i+1];
        dv = (v2-v1)/100;
        for (j=0; j<100; j++) {
          k = i*100 + j;
          trace_100sps[k] = v1 + j*dv;
          // if (i_trace==1) fprintf(stdout,"%f %e\n", k/100., trace_100sps[k]);
        }
     }
     // Finding the difference in start time and origin time (= TSTART):
     if (! xh_TsT0_diff(h_dat,&tstart)) {
        fprintf(stderr,"Error in xh_TsT0_diff()  %s/%s/%s\n", h_dat.netw,h_dat.stnm,h_dat.chan);
        exit(-1);
     }
     i_start = lrint(tstart*100./h_syn.delta);
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
     h_syn.ndata  = h_dat.ndata;
     h_syn.tstart = h_dat.tstart;
     h_syn.ot     = h_dat.ot;
     h_syn.elat   = h_dat.elat;
     h_syn.elon   = h_dat.elon;
     h_syn.edep   = h_dat.edep;
     h_syn.slat   = h_dat.slat;
     h_syn.slon   = h_dat.slon;
     h_syn.chid   = h_dat.chid;
    // strcpy(h_syn.netw,h_dat.netw);
    // strcpy(h_syn.stnm,h_dat.stnm);
     strcpy(h_syn.chan,h_dat.chan);
     strcpy(h_syn.wavf,"dis");

     // Decimating the synthetics by a factor of 100
     for (i=0; i<h_syn.ndata; i++) {
          synt[i] = 0.;
          k = i*100;
          synt[i] = trace_100sps_cpy[k];
          //if (i_trace==1) fprintf(stdout,"%i %e\n", i, synt[i]);
     }
     // WRITE XH header and data
     fprintf(stdout,"Writing SYN:  --%s--%s--%s--\n", h_syn.netw,h_syn.stnm,h_syn.chan);
     if (! xh_writehead(xhsfl,h_syn))
       exit (-1);
     if (! xh_writedata(xhsfl,h_syn,synt))
       exit (-1);
        
    
  }

}

exit( 0 );
} 

int usage()
{
fprintf(stderr,"Usage: excit_2xh dat_XH out_XH\n");
return(-1);
}
