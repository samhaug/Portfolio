#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"		// XH   structures

// Sets the quality factor into the XH header

main(argc,argv)
int argc;
char *argv[];
{
xhhed 	h;
int 	icount=1;
int 	i, ierr;
int     q;
char    ss[20];

int still_reading_data = 1;
float seism[XH_NPTS];

FILE *ifl, *ofl, *fopen();

int usage();


if(argc != 5) usage();
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
  q = atoi(argv[4]);
}

while (still_reading_data) {
  if   (! xh_readhead(ifl,&h)) {
    still_reading_data = 0;
    exit(0);
  } else {
    if (! xh_readdata(ifl,h,seism)) {
      still_reading_data = 0;
      exit(0);
    }
  }
  // check header
  if (! xh_checkheader(h) )
    exit(-1);

  // STDOUT output
  // fprintf(stdout,"XH v%4.2f  CMT: %s", h.version,h.cmtcd);
  // fprintf(stdout,"%3d %-4s %-2s %-3s  Q= %d  NewQ= %d\n",
  //      icount,h.stnm,h.netw,h.chan,h.qual,q);
  h.qual = q;
  if (! xh_writehead(ofl,h))
    exit (-1);
  if (! xh_writedata(ofl,h,seism)) 
    exit (-1);

  icount++;
} // while

fclose (ifl);
fclose (ofl);
}

int usage()
        {
        fprintf(stderr,"Usage: xh_setqual in_XHfile out_XHfile -q Qual\n");
        return(-1);
}
