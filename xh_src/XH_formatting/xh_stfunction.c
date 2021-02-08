#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <malloc.h>
#include "xhhead.h"
#include "DComplex.h"

#define MAX_NPTS 262144

// ------------------------------------------------------------
// Insert source time function
// triangular source modulation


main(argc,argv)
int argc;
char *argv[];
{
xhhed h;
float f[MAX_NPTS],fnew[MAX_NPTS];
FILE *ifl, *ofl, *fopen();

int i;
int ierr;
int still_reading_data = 1;

int NFFT = MAX_NPTS;
int numsamp = 0;

// half duration
float hdur;

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
  sscanf(argv[4],"%f", &hdur); 
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
  fprintf(stdout,"%s %-4s %2s %3s ",h.cmtcd,h.stnm,h.netw,h.chan);
  fprintf(stdout,"ndata= %d dt= %7.3f\n",h.ndata,h.delta);

  if (hdur > 0.) {
    // Detrend the data
    if (! detrend(f, h.ndata)) exit(-1);
    // Convolve with STF
    if (! stfconvolve(hdur,h.ndata,h.delta,f,fnew) )
      exit(-1);
    /* WRITE XH header and data */
    if (! xh_writehead(ofl,h))
      exit(-1);
    if (! xh_writedata(ofl,h,fnew))
      exit(-1);
  } else {
    /* WRITE original data */
    if (! xh_writehead(ofl,h))
      exit(-1);
    if (! xh_writedata(ofl,h,f))
      exit(-1);
  }
} // while

fclose(ifl);
fclose(ofl);
exit (0);
}

int usage()
{
  fprintf(stderr,"Usage: xh_stfunction in_XHfile out_XHfile -t Half_Dur (s)\n");
  return(-1);
}
