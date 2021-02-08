#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"		// XH   structures

// Inserts header values from file into the XH header

main(argc,argv)
int argc;
char *argv[];
{
xhhed 	h;
int 	icount=1;
int 	i, ierr;
int     n;
char    ss[20];

int still_reading_data = 1;
float seism[XH_NPTS];

FILE *ifl, *ofl, *hfl, *fopen();

int usage();


if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     exit(ierr);
}
if ((ofl = fopen(argv[2],"w")) == NULL) {
     ierr = usage();
     exit(ierr);
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

  i=3;
  while ( i < argc ) {
    sscanf(argv[i],"%s", ss);
    if (strncmp(ss,"elat",4)==0) sscanf(ss,"%*5s%f", &h.elat);
    if (strncmp(ss,"elon",4)==0) sscanf(ss,"%*5s%f", &h.elon);
    if (strncmp(ss,"edep",4)==0) sscanf(ss,"%*5s%f", &h.edep);
    if (strncmp(ss,"magn",4)==0) sscanf(ss,"%*5s%f", &h.Mb);
    if (strncmp(ss,"slat",4)==0) sscanf(ss,"%*5s%f", &h.slat);
    if (strncmp(ss,"slon",4)==0) sscanf(ss,"%*5s%f", &h.slon);
    if (strncmp(ss,"elev",4)==0) sscanf(ss,"%*5s%f", &h.elev);

    if (strncmp(ss,"azim",4)==0) sscanf(ss,"%*5s%f", &h.azim);
    if (strncmp(ss,"incl",4)==0) sscanf(ss,"%*5s%f", &h.incl);
    if (strncmp(ss,"qual",4)==0) sscanf(ss,"%*5s%f", &h.qual);

    if (strncmp(ss,"netw",4)==0) sscanf(ss,"%*5s%s", &h.netw);
    if (strncmp(ss,"stnm",4)==0) sscanf(ss,"%*5s%s", &h.stnm);
    if (strncmp(ss,"chan",4)==0) sscanf(ss,"%*5s%s", &h.chan);
    i=i+1;
  }

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
        fprintf(stderr,"Usage: xh_insqual in_XHfile out_XHfile -f QualFile\n");
        return(-1);
}
