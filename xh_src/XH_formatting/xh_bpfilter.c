#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "xhhead.h"
#include "DComplex.h"

// ------------------------------------------------------------
// Bandpass filter

int main(argc,argv)
int argc;
char *argv[];
{
xhhed h;
float f[XH_NPTS],fnew[XH_NPTS];
FILE *ifl, *ofl, *fopen();

float taptime;
int i;
int ierr;
int still_reading_data = 1;

int NFFT = XH_NPTS;
int numsamp = 0;

int if1,if2,if3,if4;	// bandpass filter frequencies
			// THESE ARE INTEGERS (mHz) !!!

int usage();

if(argc != 10) {
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
  sscanf(argv[4],"%f", &taptime); 
}
if (strncmp(argv[5],"-f",2) != 0) {
     ierr = usage();
     return(ierr);
} else {
  if1= atoi(argv[6]); 
  if2= atoi(argv[7]);
  if3= atoi(argv[8]);
  if4= atoi(argv[9]);
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
  fprintf(stdout,"ndata= %d dt= %7.3f taptime= %5.2f\n",h.ndata,h.delta,taptime);

  // Detrend the data
  if (! detrend(f, h.ndata)) exit(-1);
  // Taper
  if (! taper(f,h.delta,h.ndata,taptime)) exit(-1);
  // Bandpass filter
  i = bpfilter(if1,if2,if3,if4,h.ndata,h.delta,f,fnew);
// if (! bpfilter(if1,if2,if3,if4,h.ndata,h.delta,f,fnew) )
//   exit(-1);
  // Detrend the data
  // assign frequency bands to header integer
  h.intg[0] = if1;
  h.intg[1] = if2;
  h.intg[2] = if3;
  h.intg[3] = if4;
  if (! detrend(fnew, h.ndata)) exit(-1);
  /* WRITE XH header and data */
  if (! xh_writehead(ofl,h))
    exit(-1);
  if (! xh_writedata(ofl,h,fnew))
    exit(-1);
} // while

fclose(ifl);
fclose(ofl);
}

int usage()
{
  fprintf(stderr,"Usage: xh_bpfilt in_XHfile out_XHfile -t TAPER -f f1 f2 f3 f4 (mhZ)\n");
  return(-1);
}
