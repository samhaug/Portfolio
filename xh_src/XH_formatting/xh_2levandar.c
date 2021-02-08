/*
 * xh_2levander - write ascii data for Alan Levander at Rice
 *
 */

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <malloc.h>
#include "xhhead.h"

main( argc, argv )
int   argc;
char       *argv[];
{
    float     seism[XH_NPTS];
    int       index = 0, j,nstns=0;
    int       still_reading_data = 1;
    int	      ierr;
    xhhed     h;
    char      ascfile[80];
    FILE     *ifl, *fopen();


if (argc == 2) {
  if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     exit(ierr);
   }
} else {
  ierr = usage();
  exit(ierr);
}

/* Loop over traces on stdin. */
while (still_reading_data) {
  if    (! xh_readhead(ifl,&h)) {
     exit(-1);
  } else {
     if (! xh_readdata(ifl,h,seism))
       exit(-1);
     // check header
     if (! xh_checkheader(h))
       exit(-1);

     if (h.stnm[3] == ' ') { 
        sprintf(ascfile,"%.7s.%.3s.Q=%d.xy",h.cmtcd,h.stnm,h.qual);
     } else {
        sprintf(ascfile,"%.7s.%.4s.Q=%d.xy",h.cmtcd,h.stnm,h.qual);
        if (! xh_writeasc2(h,seism,ascfile)) {
          fprintf(stderr,"Error in xh_writeasc2() ...\n");
        }
     }
  }
} // while

fclose(ifl);
exit( 0 );
} 

int usage()
{
fprintf(stderr,"Usage: xh_2levander in_XH \n");
return(-1);
}
