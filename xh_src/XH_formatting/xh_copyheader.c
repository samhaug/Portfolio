#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"	/* XH format structures */

// Reads the header of an XH file and stores it in a file
// xh_copyheader in_XH out_XHHED


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
FILE *ifl, *ofl, *fopen();

int usage();

if (argc != 3) usage();
if ((ifl = fopen(argv[1],"r")) == NULL) {
   ierr = usage();
   return(ierr);
}
if ((ofl = fopen(argv[2],"w")) == NULL) {
   ierr = usage();
   return(ierr);
}

while (still_reading_data) {
  if   (! xh_readhead(ifl,&h)) {
    still_reading_data = 0;
    exit(-1);
  } else {	
    if (! xh_readdata(ifl,h,seism)) {
      still_reading_data = 0;
      exit(-1);
    }
    // check header
    if (! xh_checkheader(h) )
      exit(-1);

    // STDOUT
    fprintf(stdout,"Storing %-3d xh%4.2f %7s %-4s %-2s %-3s",
           icount,h.version,h.cmtcd,h.stnm,h.netw,h.chan);
    fprintf(stdout," %6d  %5.3f %s Q=%d\n",
           h.ndata,h.delta,h.wavf,h.qual);
    // WRITE XH header only
    if (! xh_writehead(ofl,h))
    exit(-1);
    icount++;
  }
} // while

fclose (ifl);
fclose (ofl);
fflush(stdout);
}

int usage()
{
fprintf(stderr,"xh_copyheader in_XH out_XHHED\n");
return(-1);
}
