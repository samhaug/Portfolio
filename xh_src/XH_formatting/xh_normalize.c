#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <malloc.h>
#include "xhhead.h"
#include "Complex.h"

// ------------------------------------------------------------
// Dive the trace by its maximum value

main(argc,argv)
int argc;
char *argv[];
{
xhhed h;
float f[XH_NPTS];
float maxv;

FILE *ifl, *ofl, *fopen();

int i,k;
int ierr;
int still_reading_data = 1;

int usage();

if(argc != 3) {
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
  maxv = 0.;
  fprintf(stdout,"%s %-4s %2s %3s ",h.evtcd,h.stnm,h.netw,h.chan);
  fprintf(stdout,"ndata= %d dt= %7.3f\n",h.ndata,h.delta);
  for( i=0; i<h.ndata; i++)
     if ( fabs(f[i]) > maxv) maxv = f[i];
  for( i=0; i<h.ndata; i++)
     f[i] = f[i]/maxv;

 /* WRITE XH header and data */
  if (! xh_writehead(ofl,h))
    exit(-1);
  if (! xh_writedata(ofl,h,f))
    exit(-1);
} // while

fclose(ifl);
fclose(ofl);
exit (0);
}

int usage()
{
  fprintf(stderr,"Usage: xh_normalize in_XHfile out_XHfile\n");
  return(-1);
}
