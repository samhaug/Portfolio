#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <sys/param.h>
#include "xhhead.h"

// Read and write for debugging


main(argc,argv)
int argc;
char *argv[];
{
xhhed	h;

int 	icount=1;
int 	i, ierr;

int still_reading_data = 1;
float seism[XH_NPTS];

FILE *ifl, *ofl, *fopen();

int usage();

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

  fprintf(stdout,"%-3d xh%4.2f %3.0fkm -%s- -%s- -%s- %d %3.0f %3.0f ",
       icount,h.version,h.edep,h.stnm,h.netw,h.chan,h.chid,h.azim,h.incl);
  fprintf(stdout,"%6d  %5.3f -%s- %d ",
       h.ndata,h.delta,h.wavf,h.qual);
  fprintf(stdout,"\n");  
  icount++;

  if (! xh_writehead(ofl,h))
      exit(-1);
  if (! xh_writedata(ofl,h, seism))
    exit(-1);
  }

} // while

fclose(ifl);
}

int usage(flnm)
char *flnm;
{
fprintf(stderr,"Usage: xh_2xh in_XH out_XH\n");
return(-1);
}
