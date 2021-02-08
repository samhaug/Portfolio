#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <malloc.h>
#include "xhhead.h"

// ------------------------------------------------------------
// Insert time shift ---
// mostly applied to CMT synthetics that
// do not yet have origin time shifts.


main(argc,argv)
int argc;
char *argv[];
{
xhhed h;
float f[XH_NPTS],fnew[XH_NPTS];
FILE *ifl, *ofl, *fopen();

int i;
int ierr;
int still_reading_data = 1;

int NFFT = XH_NPTS;
int numsamp = 0;

// time shift
float tshift;

int usage();

if(argc != 5) {
   ierr = usage();
   exit(ierr);
}
if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     return(ierr);
}
if ((ofl = fopen(argv[2],"w")) == NULL) {
     ierr = usage();
     return(ierr);
}
if (strncmp(argv[3],"-t",2) != 0) {
     ierr = usage();
     return(ierr);
} else {
  sscanf(argv[4],"%f", &tshift); 
}

while (still_reading_data) {
  if   (! xh_readhead(ifl,&h)) {
    still_reading_data = 0;
    exit(0);
  } else {
    if (! xh_readdata(ifl,h,f)) {
      still_reading_data = 0;
      exit(0);
    }
  }
  // check header:
  if (! xh_checkheader(h) )
      exit(-1);
  
  if (! timeshift(tshift,h.ndata,h.delta,f,fnew) )
    exit(-1);
   

  /* WRITE XH header and data */
  if (! xh_writehead(ofl,h))
    exit(-1);
  if (! xh_writedata(ofl,h,fnew))
    exit(-1);
} // while

fclose(ifl);
fclose(ofl);
exit (0);
}

int usage()
{
  fprintf(stderr,"Usage: xh_timeshift in_XHfile out_XHfile -t SHIFT (s)\n");
  return(-1);
}
