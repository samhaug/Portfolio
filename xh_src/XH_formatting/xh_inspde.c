#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"		// XH   structures
#include "cmt.h"		// CMT  structure
#include "pde.h"		// PDE  structure
#include "time.h"		// TIME structure

// Inserts PDE info into the XH header
// xh_header -c FILE


main(argc,argv)
int argc;
char *argv[];
{
xhhed 	h;
int 	icount=1;
int 	i, ierr;

int fill_cmtheader();

pdehed  pde;
cmthed  cmt;
char pdecode[11];
int still_reading_data = 1;
float seism[XH_NPTS];

float tdiff;

char infile[80];
FILE *ifl, *ofl, *fopen();

int usage();

if(argc != 5) usage("");
if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     return(ierr);
}
if ((ofl = fopen(argv[2],"w")) == NULL) {
     ierr = usage();
     return(ierr);
}
if (strncmp(argv[3],"-c",2) != 0) {
     ierr = usage();
     return(ierr);
} else {
  strcpy(pdecode,argv[4]);
}

while (still_reading_data) {
  if   (! xh_readhead(ifl,&h)) {
    still_reading_data = 0;
    exit(0);
  } else {
    if (! xh_readdata(ifl,h,seism))
      exit(0);
  }
  // check header
  if (! xh_checkheader(h) )
    exit(-1);

  if (icount == 1) {
    // Warn if CMT has already been set
    // The default value from RDSEED is 000000A
    if (strncmp(h.cmtcd,"000000A",7) != 0) {
      fprintf(stdout,"\nWarning !!!  Previously, %s was set.\n",h.cmtcd);
    }
  }

  /* X_HEADER VERSION + PDE INFO:  */
  if (! fill_pdeheader(pdecode,&pde)) {
    fprintf(stderr,"       PDE: %s not in PDE.bin ...\n",pdecode);
    exit(-1);
  }
  if (icount == 1) {
    fprintf(stdout,"%s %02d/%02d/%02d ",
            pde.pdecd,pde.yr,pde.mo,pde.day);
    fprintf(stdout,"%02d:%02d:%04.1f",
            pde.hr,pde.mn,pde.sec);
    fprintf(stdout," H=%3.0fkm Mb=%3.1f Ms=%3.1f\n\n",
            pde.dep,pde.mb,pde.ms);
  }

  h.elat = pde.lat;
  h.elon = pde.lon;
  h.edep = pde.dep;
  h.Mb = pde.mb;

  h.ot.yr  = pde.yr;
  h.ot.mo  = pde.mo;
  h.ot.day = pde.day;
  h.ot.hr  = pde.hr;
  h.ot.mn  = pde.mn;
  h.ot.sec = pde.sec;

  icount++;
  // Warn if h.tstart-h.ot is more than 6 hours
  if (! xh_TsT0_diff(h,&tdiff))
    exit(-1);
  if (fabs(tdiff) > 6.*3600.)
    fprintf(stdout,"Warning !!! ot-tstart > 6 hours %s %s ...\n",h.stnm,h.chan);
  // WRITE XH header and data
  if (! xh_writehead(ofl,h))
    exit(-1);
  if (! xh_writedata(ofl,h,seism)) 
    exit(-1);
} // while 

fclose (ifl);
fclose (ofl);
}

int usage()
        {
        fprintf(stderr,"Usage: xh_inscmt in_XHfile out_XHfile -c PDE\n");
        return(-1);
}
