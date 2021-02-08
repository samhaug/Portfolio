#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <malloc.h>
#include "xhhead.h"
#include "Complex.h"

// ------------------------------------------------------------
// flips the trace if between t1 and t2 the maximum value
// is negative
// This routine is originally meant to flip receiver
// functions with a negative polarity around t=20 s

main(argc,argv)
int argc;
char *argv[];
{
xhhed h;
float f[XH_NPTS];
float t1, t2, min, max;
FILE *ifl, *ofl, *fopen();

int i,k;
int i1, i2, imin, imax;
int ierr;
int still_reading_data = 1;

int usage();

if(argc != 6) {
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
  sscanf(argv[4],"%f",&t1); 
  sscanf(argv[5],"%f",&t2); 
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
  // find the maximum and minimum values
  i1 = t1/h.delta;
  i2 = t2/h.delta;
  max = f[i1];
  imax = i1;
  min = f[i1];
  imin = i1;
  for (i=i1+1;i<=i2;i++) {
    if ( f[i] > max ) {
       max = f[i];
       imax = i;
    }
    if ( f[i] < min ) {
       min = f[i];
       imin = i;
    }
  }
  // if MIN is negative, and at least 1.25 times larger
  // (in absolute value) than MAX, then flip the trace
  if ( strncmp(h.chan,"RCF",3) == 0) {
   if ( min < 0. && fabs(min)/fabs(max) > 1.25) {
    fprintf(stdout,"Flipping %s %2s %-4s %3s\n",h.cmtcd,h.netw,h.stnm,h.chan);
    fprintf(stdout,"Min= %f at t= %f  Max= %f at t= %f\n",min,imin*h.delta,max,imax*h.delta);
    for (i=0;i<h.ndata;i++)
      f[i] = -1.*f[i];
   }
  }

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
  fprintf(stderr,"Usage: xh_fliprcf in_XHfile out_XHfile -t t1 t2 (s)\n");
  return(-1);
}
