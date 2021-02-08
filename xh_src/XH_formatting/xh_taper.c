#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"		// XH   structures

// tapers the first and last TAPTIME of a XH trace

main(argc,argv)
int argc;
char *argv[];
{

xhhed 	h;

int 	ierr;

int still_reading_data = 1;
float seism[XH_NPTS];
float taptime;

char infile[80];
FILE *ifl, *ofl, *fopen();

int usage();

if(argc != 5) usage("");
if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage(argv[1]);
     exit(1);
}
if ((ofl = fopen(argv[2],"w")) == NULL) {
     ierr = usage(argv[2]);
     exit(2);
}
if (strncmp(argv[3],"-t",2) != 0) {
     ierr = usage();
     exit(3);
} else {
  taptime = atof(argv[4]);
}
  fprintf(stdout,"Taper %f\n", taptime);

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

  // taper
  if (! taper(seism,h.delta,h.ndata,taptime) ) {
     fprintf(stderr,"Taper error ... \n");
     exit(1);
  }
  fprintf(stdout,"Taper %s %s %s\n", h.stnm,h.netw,h.chan);

  // WRITE XH header and data
  if (! xh_writehead(ofl,h))
    exit (-1);
  if (! xh_writedata(ofl,h,seism)) 
    exit (-1);
} // while

fclose (ifl);
fclose (ofl);
}

int usage(flnm)
char *flnm;
        {
        fprintf(stderr,"Usage: xh_taper in_XHfile out_XHfile -t TAP\n");
        return(-1);
}
