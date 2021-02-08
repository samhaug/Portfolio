#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"		/* XH format structures */

// Reads the header of an XH file and prints out 
// the location of source and stations and
// distance/azimuth/back-azimuth
//

main(argc,argv)
int argc;
char *argv[];
{
xhhed 	h;
int 	icount=1;
int 	i, ierr;

int still_reading_data = 1;
float seism[XH_NPTS];

char infile[80];
char lat, lon;
char region[23];
FILE *inf, *fopen();

float delta,az,baz;
int distaz();
int usage();

if ((inf = fopen(argv[1],"r")) == NULL) {
   ierr = usage(argv[1]);
   return(ierr);
}

while (still_reading_data) {
  if   (! xh_readhead(inf,&h)) {
    exit(-1);
  } else {	
    if (! xh_readdata(inf,h,seism))
      exit(-1);
    // check header
    if (! xh_checkheader(h))
      exit(-1);
    // get epicentral distance, azimuth and backazimuth
    if (! distaz(h.slat,h.slon,h.elat,h.elon,&delta,&az,&baz))
      exit(-1) ;
    // printf lat/lon/depth of event, netw/lat/lon of station, and dist/az/baz
    fprintf(stdout,"%7.3f %8.3f %3d  %s %-4s %7.3f %8.3f    %6.2f %6.2f %6.2f\n",
              h.elat,h.elon,(int) rintf(h.edep),h.netw,h.stnm,h.slat,h.slon,delta,az,baz);
    icount++;
  }
} // while

fclose (inf);
fflush(stdout);
}

int usage(flnm)
char *flnm;
{
fprintf(stderr,"Cannot read XH file: %s\n",flnm);
return(-1);
}
