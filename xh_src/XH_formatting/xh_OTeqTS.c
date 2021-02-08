#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"		// XH   structures

// OT (origin time) = TS (start time)

main(argc,argv)
int argc;
char *argv[];
{
xhhed 	h;
int 	icount=1;
int 	i, ierr;
int     q;
char    ss[20];

int still_reading_data = 1;
float seism[XH_NPTS];

FILE *ifl, *ofl, *fopen();

int usage();

fprintf(stdout,"a1\n");

if (argc != 3) {
   ierr = usage();
   exit(-1);
}
fprintf(stdout,"a2\n");
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

  h.ot.yr  = h.tstart.yr;
  h.ot.mo  = h.tstart.mo;
  h.ot.day = h.tstart.day;
  h.ot.hr  = h.tstart.hr;
  h.ot.mn  = h.tstart.mn;
  h.ot.sec = h.tstart.sec;

  if (! xh_writehead(ofl,h))
    exit (-1);
  if (! xh_writedata(ofl,h,seism)) 
    exit (-1);

  icount++;
} // while

fclose (ifl);
fclose (ofl);
}

int usage()
        {
        fprintf(stderr,"Usage: xh_OTeqTS in_XHfile out_XHfile\n");
        fprintf(stderr,"       setting OT equal to TSTART\n");
        return(-1);
}
