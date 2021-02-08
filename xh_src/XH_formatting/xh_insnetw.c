#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"		// XH   structures

// Inserts network name into the XH header

main(argc,argv)
int argc;
char *argv[];
{
xhhed 	h;
int 	i, ierr;
int jdebug = 0;
int     n;
char    ss[20];
char    netw[6];

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
if (strncmp(argv[3],"-n",2) != 0) {
     ierr = usage();
     exit(ierr);
} else {
     sprintf(netw, "%s", argv[4]);
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

  sprintf(h.netw,"%s", netw);
  if (jdebug)
    fprintf(stdout,"xh_insnetw(): inserting NETW=%s into header: %s %s %s\n", netw, h.netw,h.stnm,h.chan);
  if (! xh_writehead(ofl,h))
    exit (-1);
  if (! xh_writedata(ofl,h,seism)) 
    exit (-1);

} // while

fclose (ifl);
fclose (ofl);
}

int usage()
        {
        fprintf(stderr,"Usage: xh_insnetw in_XHfile out_XHfile -n NETW\n");
        return(-1);
}
