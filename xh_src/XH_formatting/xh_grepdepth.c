/*
  xh_grepdepth - selects data from XH file
  with depths between h_min and h_max.
*/

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
    int       index = 0, i,j;
    int       still_reading_data = 1;
    int	      ierr;
    xhhed     h;
    FILE     *ifl, *ofl, *fopen();
    float     h_min, h_max; // range of depths allowed

if (argc == 6) {
 if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     exit(ierr);
 }
 if ((ofl = fopen(argv[2],"w")) == NULL) {
     ierr = usage();
     exit(ierr);
 }
 if (strncmp(argv[3],"-d",2) != 0) {
     ierr = usage();
     exit(ierr);
 } else {
     sscanf(argv[4],"%f", &h_min);
     sscanf(argv[5],"%f", &h_max);
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
     if ( h.edep>=h_min && h.edep<=h_max ) {
          fprintf(stdout,"Writing CMT: %s %s %-4s %3s H=%3.0f\n", h.evtcd,h.netw,h.stnm,h.chan,h.edep);
       // WRITE XH header and data
       if (! xh_writehead(ofl,h))
         exit(-1);
       if (! xh_writedata(ofl,h,seism))
         exit(-1);
     }
  }
} // while

fclose(ifl);
fclose(ofl);
exit( 0 );
} 

int usage()
{
fprintf(stderr,"Usage: xh_grepdepth in_XH out_XH -d H_min H_max\n");
return(-1);
}
