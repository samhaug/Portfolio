//
// sac_2xh - Turn SAC into XH 
//
// Primarily used to write SAC from RDSEED data into XH
// I am assuming that the instruments have already been taken out

// J. Ritsema, IPGP, March 2004.


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "xhhead.h"

main( argc, argv )
int   argc;
char       *argv[];
{
    float     seism[XH_NPTS];
    int       index = 0, j,nstns=0;
    int       still_reading_data = 1;
    int       useful;
    int	      ierr;
    int       jdebug = 1;
    int       locc;
    int       k;
    xhhed     h;
    char      location[3];
    char      sacfile[80];
    char      ret_pzfile[80];
    char      std_pzfile[80];
    char      opt_pzfile[80];
    FILE     *ifl, *ofl, *fopen();


if (argc == 1) {
   ierr = usage();
   exit(ierr);
}
strcpy(sacfile,argv[1]);
if ((ofl = fopen(argv[2],"w")) == NULL) {
   ierr = usage();
   exit(ierr);
}
index = 2;
while ( ++index < argc && argv[index][0] == '-' ){
  switch ( argv[index][1] ){
     case 'l':
        // location code
        if ( sscanf( argv[++index], "%d", &locc ) != 1) {
            ierr = usage();
            exit(ierr);
        }
        break;
     default:
        ierr = usage();
        exit(ierr);
  }
}

if (! xh_setdefaults(&h)) {
  fprintf(stderr,"Error xh_setdefaults() ...\n");
  exit(-1);
}
if (jdebug) {
  fprintf(stdout,"\n-----sac_2xh()------\n");
  fprintf(stdout,"sacfile= --%s--\n", sacfile);
}

// Read SAC file
if (! xh_readsac(&h,seism,sacfile,&useful)) {
   fprintf(stderr,"error running xh_readsac() ...\n");
   exit(-1);
}

if (jdebug) {
  fprintf(stdout,"stnm= --%s--\n", h.stnm);
  fprintf(stdout,"chan= --%s--\n", h.chan);
  fprintf(stdout,"useful= %d\n", useful);
  fprintf(stdout,"ot= %4d/%02d/%02d ", h.ot.yr,h.ot.mo,h.ot.day);
  fprintf(stdout,"%02d:%02d:%5.2f\n",  h.ot.hr,h.ot.mn,h.ot.sec);
  fprintf(stdout,"st= %4d/%02d/%02d ", h.tstart.yr,h.tstart.mo,h.tstart.day);
  fprintf(stdout,"%02d:%02d:%5.2f\n",  h.tstart.hr,h.tstart.mn,h.tstart.sec);
}
if (useful) {
  // From command line input:
  //h.locc = locc;
  fprintf(stdout,"--%s-- --%s-- Locc= %d   ",h.netw,h.stnm,h.locc);
  fprintf(stdout,"DT= %5.2f N= %d\n",h.delta,h.ndata);
  // WRITE XH header and data
  if (! xh_writehead(ofl,h))
  exit (-1);
  if (! xh_writedata(ofl,h,seism))
    exit (-1);
} else {
  fprintf(stderr,"sac_2xh() not useful -%s- -%s- -%s-\n",h.netw,h.stnm,h.chan);
}

fclose(ofl);
exit( 0 );
} 

int usage()
{
fprintf(stderr,"Usage: sac_2xh in_SAC out_XH -l LOCATION\n");
return(-1);
}

/*

  if        ((ifl = fopen(ret_pzfile,"r")) != NULL) {
    // fprintf(stdout,"PZfile: ./%s\n", ret_pzfile);
    if (xh_insPoleZero(ret_pzfile,&h) == 0) {
      fprintf(stderr,"%s error running xh_insPoleZero() ...\n", ret_pzfile);
      exit(-1);
    }
  } else if ((ifl = fopen(std_pzfile,"r")) != NULL) {
    // fprintf(stdout,"PZfile: %s\n", std_pzfile);
    if (xh_insPoleZero(std_pzfile,&h) == 0) {
      fprintf(stderr,"%s error running xh_insPoleZero() ...\n", std_pzfile);
      exit(-1);
    }
  } else if ((ifl = fopen(opt_pzfile,"r")) != NULL) {
    // fprintf(stdout,"PZfile: %s\n", opt_pzfile);
    if (xh_insPoleZero(opt_pzfile,&h) == 0) {
      fprintf(stderr,"%s error running xh_insPoleZero() ...\n", opt_pzfile);
      exit(-1);
    }
  } else {
       fprintf(stdout,"Pole/Zero info not available for XH header !!\n");
  }

  // old piece of code:
  // Getting response info from the PoleZero file
  // USED TO:
  // We assume that its name is: SAC_PZs.stnm.netw.location.chan
  // For example:	SAC_PZs.KONO.IU.10.BHE
  // or		SAC_PZs.BDM.BK..BHE
  // NOW
  // We assume that its name is: SAC_PZs_netw_stnm_chan_location
  // For example:	SAC_PZs_II_DGAR_LHE_00
  // or
  // i		SAC_PZs_II_DGAR_LHE
  //
  // We look for the PoleZero file in the current directory. 
  // If it does not exist there, we look in the directory:
  // /work/jeroen/Utils/Instruments/PoleZero_files
  
  // sprintf(ret_pzfile,"SAC_PZs_%s_%s_%s_%s",h.netw,h.stnm,h.chan,location);
  // sprintf(opt_pzfile,"SAC_PZs_%s_%s_%s_",h.netw,h.stnm,h.chan);
  // sprintf(std_pzfile,"/Users/jritsema/Utils/Instruments/PoleZero_files/SAC_PZs_%s_%s_%s_%s",h.netw,h.stnm,h.chan,location);
  
  if        (h.stnm[3] == ' ') {
    sprintf(ret_pzfile,"SAC_PZs_%s_%3s_%s_%s",h.netw,h.stnm,h.chan,location);
    sprintf(opt_pzfile,"SAC_PZs_%s_%3s_%s_",h.netw,h.stnm,h.chan);
    sprintf(std_pzfile,"/work/jeroen/Utils/Instruments/PoleZero_files/SAC_PZs_%s_%3s_%s_%s",h.netw,h.stnm,h.chan,location);
  } else if (h.stnm[4] == ' ') {
    sprintf(ret_pzfile,"SAC_PZs_%s_%4s_%s_%s",h.netw,h.stnm,h.chan,location);
    sprintf(opt_pzfile,"SAC_PZs_%s_%4s_%s_",h.netw,h.stnm,h.chan);
    sprintf(std_pzfile,"/work/jeroen/Utils/Instruments/PoleZero_files/SAC_PZs_%s_%4s_%s_%s",h.netw,h.stnm,h.chan,location);
  } else if (h.stnm[5] == ' ') {
    sprintf(ret_pzfile,"SAC_PZs_%s_%5s_%s_%s",h.netw,h.stnm,h.chan,location);
    sprintf(opt_pzfile,"SAC_PZs_%s_%5s_%s_",h.netw,h.stnm,h.chan);
    sprintf(std_pzfile,"/work/jeroen/Utils/Instruments/PoleZero_files/SAC_PZs_%s_%5s_%s_%s",h.netw,h.stnm,h.chan,location);
  } else {
    fprintf(stderr,"sac_2xh() -- station string length ... --%s-- --%s-- \n", h.netw, h.stnm);
    fprintf(stdout,"sac_2xh() -- station string length ... --%s-- --%s-- \n", h.netw, h.stnm);
  }
*/
