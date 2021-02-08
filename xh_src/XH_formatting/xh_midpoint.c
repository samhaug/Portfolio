/*
  xh_midpoint - prints out the midpoint between source and receiver
  mostly useful for getting SS and PP reflection poijts for shallow sources
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <malloc.h>
#include "xhhead.h"

main( argc, argv )
int   argc;
char       *argv[];
{
    float     seism[XH_NPTS];
    float     delta,az,baz;
    float     bcp_lat, bcp_lon;
    int       index = 0;
    int       still_reading_data = 1;
    int	      ierr;
    xhhed     h;
    FILE     *ifl, *ofl, *fopen();

    int distaz();


 if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     exit(ierr);
 }

// Loop over traces on stdin
while (still_reading_data) {
  if    (! xh_readhead(ifl,&h)) {
     exit(-1);
  } else {
     if (! xh_readdata(ifl,h,seism))
       exit(-1);
     // Get distance (degrees)
     if (! distaz(h.slat,h.slon,h.elat,h.elon,&delta,&az,&baz))
       exit(-1) ;
     // BCP_lat/lon is the SS surface reflection location
     if (! distaz2latlon(h.elat,h.elon,delta/2.,az,&bcp_lat,&bcp_lon))
          exit(-1);
     fprintf(stdout,"%7.2f %8.2f\n", bcp_lat,bcp_lon);
  }
} // while

fclose(ifl);
} 

int usage()
{
fprintf(stderr,"Usage: xh_midpoint in_XH\n");
return(-1);
}
