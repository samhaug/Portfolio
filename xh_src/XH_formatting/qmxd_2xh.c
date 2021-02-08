//
// qmxd_2xh - Turns ASCII seismograms from QmXD into XH 
//
// Assuming that the synthetics are in SYNT, and that
// they have been generated using the info in DATA/RECORDHEADERS
//
// J. Ritsema, Univ. Michigan, October 2006.


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <malloc.h>
#include "xhhead.h"
#include "time.h"
#include "ndk.h"

//------------------------------------------------------------------------
// Assumptions !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// (-) Z,R,T in data have same number of samples and same start times
// (-) QmXD synthetics have 4096 samples
// (-) QmXD synthetics have dt = 1s
#define NSYNT    4096
//------------------------------------------------------------------------

main( argc, argv )
int   argc;
char       *argv[];
{
    float     data[XH_NPTS];
    float     synt[XH_NPTS];
    float     z_trace[NSYNT];
    float     n_trace[NSYNT];
    float     e_trace[NSYNT];
    float     r_trace[NSYNT];
    float     t_trace[NSYNT];
    float     tstart;
    float     rad;
    float     delta, az, baz;
    float     taper;

    int       index = 0;
    int       still_reading_data = 1;
    int	      ierr;
    int       i_onehour = 3600;
    int       i_stnm, i_netw;
    int       i,j,k;

    xhhed     h_dat, h_syn;
    xh_time   otime, stime;
    cmthed    cmt;

    char      evtcode[8], region[18];
    char      qmxd_file[80];
    char      z_file[80];
    char      n_file[80];
    char      e_file[80];
    char      xh_data[80];
    char      ss[130];
    FILE     *xhdfl, *xhsfl, *cmtfl, *zfl, *nfl, *efl, *fopen();


if (argc != 5) {
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
if (strncmp(argv[3],"-c",2) != 0) {
     ierr = usage();
     return(ierr);
} else {
     strncpy(evtcode,argv[4],7);
     ierr   = iswhite(evtcode,&k);
     if (k != 7) {
       ierr = usage();
       exit(-1);
     }
}

rad = 4.*atan(1.)/180.;

/*-- GET CMT info ------------------- */
memset(region,0,sizeof(region));
if (! fill_cmtheader(evtcode,&cmt)) {
  fprintf(stderr,"CMT: %s not in CMT.bin ...\n",evtcode);
  exit(-1);
}
strncpy(region,cmt.region,18); region[18]='\0';

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
     // z-comp
     ierr   = iswhite(h_dat.stnm,&i_stnm);
     ierr   = iswhite(h_dat.netw,&i_netw);
     fprintf(stdout,"XH ---%s-%d---%s-%d---%s-- id=%d\n", h_dat.stnm,i_stnm,h_dat.netw,i_netw,h_dat.chan,h_dat.chid);
     if ( strncmp(h_dat.chan,"LHZ",3)==0 && h_dat.chid==1 ) {
        if        (i_stnm == 3) {
             sprintf(z_file,"SYNT/%.3s.%s.LHZ.qmxd", h_dat.stnm,h_dat.netw);
             sprintf(n_file,"SYNT/%.3s.%s.LHN.qmxd", h_dat.stnm,h_dat.netw);
             sprintf(e_file,"SYNT/%.3s.%s.LHE.qmxd", h_dat.stnm,h_dat.netw);
        } else if (i_stnm == 4) {
             sprintf(z_file,"SYNT/%.4s.%s.LHZ.qmxd", h_dat.stnm,h_dat.netw);
             sprintf(n_file,"SYNT/%.4s.%s.LHN.qmxd", h_dat.stnm,h_dat.netw);
             sprintf(e_file,"SYNT/%.4s.%s.LHE.qmxd", h_dat.stnm,h_dat.netw);
        } else {
          fprintf(stderr,"STATION NAME PROBLEM?? --%s-- --%s--\n", h_dat.stnm, h_dat.netw);
          exit(-1);
        }
        if ( (zfl = fopen(z_file,"r")) == NULL ) {
           fprintf(stderr,"Cannot open Z-comp synthetics: %s\n", z_file);
           exit(-1);
        }
        if ( (nfl = fopen(n_file,"r")) == NULL ) {
           fprintf(stderr,"Cannot open N-comp synthetics: %s\n", n_file);
           exit(-1);
        }
        if ( (efl = fopen(e_file,"r")) == NULL ) {
           fprintf(stderr,"Cannot open E-comp synthetics: %s\n", e_file);
           exit(-1);
        }
        for(i=0;i<NSYNT;i++) {
            fscanf(zfl,"%*f %f", &z_trace[i]);
            fscanf(nfl,"%*f %f", &n_trace[i]);
            fscanf(efl,"%*f %f", &e_trace[i]);
        }
        // Done reading the QmXD synthetics
     

        // Rotate into radial and transverse using the algorith from xh_rotate()
        // The back azimuth is taken from the XH header of the data file H_dat
        // Get backazimuth baz (degrees)
        if (! distaz(h_dat.slat,h_dat.slon,h_dat.elat,h_dat.elon,&delta,&az,&baz))
           exit(-1) ;

        for(i=0;i<NSYNT;i++) {
            r_trace[i] = -1.0 * cos(baz*rad)*n_trace[i] - sin(baz*rad)*e_trace[i];
            t_trace[i] =        sin(baz*rad)*n_trace[i] - cos(baz*rad)*e_trace[i];
            // following the conventions in xh_rotate()
            t_trace[i] = -1.0 * t_trace[i];
        }

        // Copying the header
        h_syn = h_dat;
        h_syn.azim   = 0.;
        h_syn.delta  = 1.0;
        h_syn.maxamp = -999.;
        h_syn.qual   = -1;

        i_onehour   = 3600;
        h_syn.ndata = i_onehour;

        // detrend
        if (! xh_detrend(z_trace,NSYNT) ) {
           fprintf(stderr,"Detrend error in Z-trace\n");
           exit(-1);
        }
        if (! xh_detrend(r_trace,NSYNT) ) {
           fprintf(stderr,"Detrend error in R-trace\n");
           exit(-1);
        }
        if (! xh_detrend(t_trace,NSYNT) ) {
           fprintf(stderr,"Detrend error in T-trace\n");
           exit(-1);
        }
        // taper
        if (! xh_taper(z_trace,h_syn.delta,NSYNT) ) {
           fprintf(stderr,"Taper error in Z-trace\n");
           exit(-1);
        }
        if (! xh_taper(r_trace,h_syn.delta,NSYNT) ) {
           fprintf(stderr,"Taper error in R-trace\n");
           exit(-1);
        }
        if (! xh_taper(t_trace,h_syn.delta,NSYNT) ) {
           fprintf(stderr,"Taper error in T-trace\n");
           exit(-1);
        }
   
        // --------------------------------------------------------------------------------
        // For Z_comp
        for (i=0; i<i_onehour; i++) {
           synt[i] = z_trace[i];
        }
        h_syn.chid   = 1;
        strncpy(h_syn.chan,"LHZ",3);
        strncpy(h_syn.wavf,"dis",3);
   
        if (! xh_writehead(xhsfl,h_syn))
          exit (-1);
        if (! xh_writedata(xhsfl,h_syn,synt))
          exit (-1);

        // --------------------------------------------------------------------------------
        // For R_comp
        for (i=0; i<i_onehour; i++) {
           synt[i] = r_trace[i];
        }
        h_syn.chid   = 4;
        strncpy(h_syn.chan,"LHR",3);
        strncpy(h_syn.wavf,"dis",3);
   
        if (! xh_writehead(xhsfl,h_syn))
          exit (-1);
        if (! xh_writedata(xhsfl,h_syn,synt))
          exit (-1);


        // --------------------------------------------------------------------------------
        // For T_comp
        for (i=0; i<i_onehour; i++) {
           synt[i] = t_trace[i];
        }
        h_syn.chid   = 5;
        strncpy(h_syn.chan,"LHT",3);
        strncpy(h_syn.wavf,"dis",3);
   
        if (! xh_writehead(xhsfl,h_syn))
          exit (-1);
        if (! xh_writedata(xhsfl,h_syn,synt))
          exit (-1);
     }        
  }
}

exit( 0 );
} 

int usage()
{
fprintf(stderr,"Usage: qmxd_2xh dat_XH out_XH -c CMT\n");
return(-1);
}
