/*
  xh_grepaz - retains data with azimuths between a1 and a2
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "xhhead.h"

//#include "xh_functions.h"

int main( argc, argv )
int   argc;
char       *argv[];
{
    float     seism[XH_NPTS];
    float     a1, a2;
    float     delta,az,baz;
    int       index = 0;
    int       still_reading_data = 1;
    int	      ierr;
    xhhed     h;
    FILE     *ifl, *ofl, *fopen();


if (argc == 6) {
 if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     exit(ierr);
 }
 if ((ofl = fopen(argv[2],"w")) == NULL) {
     ierr = usage();
     exit(ierr);
 }
 if (strncmp(argv[3],"-a",2) != 0) {
     ierr = usage();
     exit(ierr);
 } else {
     sscanf(argv[4],"%f", &a1);
     sscanf(argv[5],"%f", &a2);
 }
} else {
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
     // Get azimuth (degrees)
     if (! distaz(h.slat,h.slon,h.elat,h.elon,&delta,&az,&baz))
       exit(-1) ;
     if ( az>a1 && az<a2) {
        fprintf(stdout,"Writing data for %-4s %3s AZ= %6.2f\n",h.stnm,h.chan,az);
        // WRITE XH header and data
        if (! xh_writehead(ofl,h))
          exit(-1);
        if (! xh_writedata(ofl,h,seism))
          exit(-1);
     }
  }
} // while

fclose(ifl);
exit( 0 );
} 

int usage()
{
fprintf(stderr,"Usage: xh_grepaz in_XH out_XH -a minAZ maxAZ [deg]\n");
return(-1);
}
