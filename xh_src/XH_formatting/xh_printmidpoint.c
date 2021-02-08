#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"		// XH   structures

// Inserts S-wave traveltime into the XH header

main(argc,argv)
int argc;
char *argv[];
{
xhhed 	h;
int 	i, ierr;

int still_reading_data = 1;
float seism[XH_NPTS];

// midpoint location
float mplat, mplon;

float delta,az,baz;

char infile[80];
FILE *ifl, *fopen();

int usage();

if(argc != 2) usage("");
if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage(argv[1]);
     return(ierr);
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

  // Get midpoint 
  if (! distaz(h.slat,h.slon,h.elat,h.elon,&delta,&az,&baz))
    exit (-1);
  delta = delta/2.;
  if (! distaz2latlon(h.elat,h.elon,delta,az,&mplat,&mplon))
    exit (-1);

  fprintf(stdout,"%s %-4s %-2s %6.2f %7.2f %6.2f %7.2f   MidPoint= %7.2f %8.2f\n",
          h.evtcd,h.stnm,h.netw,h.elat,h.elon,h.slat,h.slon,mplat,mplon);
  // fprintf(stdout,"%s %-4s %-2s %6.2f %7.2f %6.2f %7.2f %4.1f %4.1f %5.1f  MidPoint= %7.2f %8.2f\n",
  //      h.evtcd,h.stnm,h.netw,h.elat,h.elon,h.slat,h.slon,2.*delta,delta,az,mplat,mplon);
} // while

fclose (ifl);
}

int usage(flnm)
char *flnm;
        {
        fprintf(stderr,"Usage: xh_printmidpoint in_XHfile\n");
        return(-1);
}
