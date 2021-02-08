/*
  xh_grepstat - selects data from XH file
  with quality factor between q_min and q_max.
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
    int       q_min, q_max; // range of quality factors
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
 if (strncmp(argv[3],"-q",2) != 0) {
     ierr = usage();
     exit(ierr);
 } else {
  q_min= atoi(argv[4]);
  q_max= atoi(argv[5]);
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
     if ( h.qual>=q_min && h.qual<=q_max ) {
       // fprintf(stdout,"Writing %s %-4s %3s Q=%d\n",h.netw,h.stnm,h.chan,h.qual);
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
fprintf(stderr,"Usage: xh_grepqual in_XH out_XH -q Q_min Q_max\n");
return(-1);
}
