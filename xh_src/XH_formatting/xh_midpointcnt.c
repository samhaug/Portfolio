/*
  xh_midpointcnt - counts the number of data with midpoint between source and receiver
  that falls with a CAP_radius from CAP_lat and CAP_lon
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
    float     BCP_lat, BCP_lon;
    float     CAP_lat, CAP_lon, CAP_rad;
    int       count = 0, min_cnt = 0;
    int       still_reading_data = 1;
    int	      ierr;
    xhhed     h;
    FILE     *ifl, *ofl, *fopen();

    int distaz();


if(argc != 8) {
  ierr = usage();
  exit(ierr);
}
if ((ifl = fopen(argv[1],"r")) == NULL) {
    ierr = usage();
    exit(ierr);
}
if (strncmp(argv[2],"-c",2) != 0) {
     ierr = usage();
     return(ierr);
} else {
  sscanf(argv[3],"%f", &CAP_lat);
  sscanf(argv[4],"%f", &CAP_lon);
  sscanf(argv[5],"%f", &CAP_rad);
}
if (strncmp(argv[6],"-n",2) != 0) {
     ierr = usage();
     return(ierr);
} else {
  sscanf(argv[7],"%d", &min_cnt);
}

// Loop over traces on stdin
while (still_reading_data) {
  if    (! xh_readhead(ifl,&h)) {
     break;
  } else {
     if (! xh_readdata(ifl,h,seism))
       exit(0);
     // Get distance (degrees)
     if (! distaz(h.slat,h.slon,h.elat,h.elon,&delta,&az,&baz))
       exit(-1) ;
     // BCP_lat/lon is the SS surface reflection location
     if (! distaz2latlon(h.elat,h.elon,delta/2.,az,&BCP_lat,&BCP_lon))
          exit(-1);
     // Get the distance between BCP_lat and BCP_lon and CAP_lat and CAP_lon
     if (! distaz(BCP_lat,BCP_lon,CAP_lat,CAP_lon,&delta,&az,&baz))
         exit(-1);
     if (delta <= CAP_rad) {
        // fprintf(stdout,"%7.2f %8.2f %4.1f\n", BCP_lat,BCP_lon, delta);
        count = count+1;
     }
  }
} // while
fclose(ifl);
if (count >= min_cnt)
  fprintf(stdout,"%6.2f %8.2f %d\n", CAP_lat,CAP_lon,count);

} 

int usage()
{
fprintf(stderr,"Usage: xh_midpointcnt XH_file -c CAP_lat CAP_lon CAP_rad -n MIN_CNT\n");
return(-1);
}
