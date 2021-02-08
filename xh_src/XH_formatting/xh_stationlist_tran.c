//
// xh_stationlist
//
// prints out station name and stlat/stlon for each trace with chan = LHT
// This list is used as input for excit_M
//
// J. Ritsema, Univ. Michigan, October 2006.


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
    float     data[XH_NPTS];
    int       still_reading_data = 1;
    int	      ierr;
    xhhed     h;
    FILE     *xfl, *fopen();

if (argc != 2) {
  ierr = usage();
  exit(ierr);
}

// XH data file
if ((xfl=fopen(argv[1],"r")) == NULL) {
     ierr=usage();
     exit(-1);
}

// Loop over traces in xfl
while (still_reading_data) {
  if    (! xh_readhead(xfl,&h)) {
     still_reading_data=0;
     break;
  } else {
     if (! xh_readdata(xfl,h,data)) {
       still_reading_data=0;
       exit(-1);
     }
     // check header
     if (! xh_checkheader(h) )
       exit(-1);
     if( strncmp(h.chan,"LHT",3) == 0 || strncmp(h.chan,"BHT",3) == 0 )
       fprintf(stdout,"%6s %4s %7.2f %8.2f\n", h.stnm,h.netw,h.slat,h.slon);
  }
}

exit( 0 );
} 

int usage()
{
fprintf(stderr,"Usage: xh_stationlist in_XH\n");
return(-1);
}
