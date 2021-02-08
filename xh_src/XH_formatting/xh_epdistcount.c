#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"	/* XH format structures */

// Determines the epicentral distance distribution 
// Used in makewing SS precursor stacks


main(argc,argv)
int argc;
char *argv[];
{
xhhed 	h;
int 	i, ierr;

int    still_reading_data = 1;
int    i_dist, count[90];
float  seism[XH_NPTS];
float  delta,az,baz;

FILE   *inf, *fopen();

int usage();

if ((inf = fopen(argv[1],"r")) == NULL) {
   ierr = usage(argv[1]);
   return(ierr);
}

while (still_reading_data) {
  if   (! xh_readhead(inf,&h)) {
    still_reading_data = 0;
    exit(-1);
  } else {	
    if (! xh_readdata(inf,h,seism)) {
      still_reading_data = 0;
      exit(-1);
    }
    // check header
    if (! xh_checkheader(h) )
      exit(-1);

    fprintf(stdout,"%s %3.0f km %-4s %-2s %-3s ",
           h.evtcd,h.edep,h.stnm,h.netw,h.chan);
    fprintf(stdout,"%6.2f %7.2f ", h.slat,h.slon);
    fprintf(stdout,"\n");  
    // Get distance (degrees)
    if (! distaz(h.slat,h.slon,h.elat,h.elon,&delta,&az,&baz))
        exit(-1) ;
    i_dist = lrintf(delta - 90.);
    count[i_dist] = count[i_dist] + 1;
  }
} // while

// STDOUT
for(i=0;i<90;i++) {
  fprintf(stdout,"%-2d %3d", i, count[i]);
}


fclose (inf);
fflush(stdout);
}

int usage()
{
fprintf(stderr,"xh_epidistcount XH file\n");
return(-1);
}
