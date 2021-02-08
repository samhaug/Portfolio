#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"		// XH format structures

// Reads the header of an XH file and
// prints out one line of header info

main(argc,argv)
int argc;
char *argv[];
{
xhhed 	h;
int 	icount=1;
int 	ierr;
int 	i;
int npoles, nzeros;

char infile[80];

int still_reading_data = 1;
int usage();
float seism[XH_NPTS];
float delta, az,baz;

FILE *inf, *fopen();

if (argc =! 2) {
  ierr = usage("");
  exit(ierr);
}
if ((inf = fopen(argv[1],"r")) == NULL) {
  ierr = usage(argv[1]); 
  exit(ierr);
}

while (still_reading_data) {
  if   (! xh_readhead(inf,&h)) {
    exit(-1);
  } else {
    if (! xh_readdata(inf,h,seism)) {
      exit(-1);
    }
    // check header
    if (! xh_checkheader(h) )
      exit(-1);
    if (! distaz(h.slat,h.slon,h.elat,h.elon,&delta,&az,&baz))
    exit (-1);
    fprintf(stdout,"%3d xh%4.2f", icount,h.version);
    fprintf(stdout," %s", h.evtcd);
    fprintf(stdout," %6.2f %7.2f %3.0fkm",h.elat,h.elon,h.edep);
    fprintf(stdout," %3s %5s %3s %d", h.netw,h.stnm,h.chan,h.chid);
    fprintf(stdout," %6.2f %7.2f D=%3.0fdeg",       h.slat,h.slon,delta);
    fprintf(stdout," %6d %5.2f %3s", h.ndata,h.delta,h.wavf);
    fprintf(stdout," A=%e", h.maxamp);
    fprintf(stdout,"\n");
    icount++;
    }
} // while 

fclose (inf);
fflush(stdout);
}

int usage(flnm)
char *flnm;
	{
	fprintf(stderr,"Cannot read XH file: %s\n",flnm);
	return(-1);
}
