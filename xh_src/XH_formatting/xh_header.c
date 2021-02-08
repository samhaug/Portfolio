#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"		/* XH format structures */

/* Reads the header of an XH file and prints out some information */
/* xh_header -c FILE */


main(argc,argv)
int argc;
char *argv[];
{
xhhed 	h;
int 	icount=1;
int 	i, ierr;

int still_reading_data = 1;
float seism[XH_NPTS];

char infile[80];
char lat, lon;
char region[23];
FILE *inf, *fopen();

int usage();

if ((inf = fopen(argv[1],"r")) == NULL) {
   ierr = usage(argv[1]);
   return(ierr);
}


while (still_reading_data) {
  if   (! xh_readhead(inf,&h)) {
    exit(-1);
  } else {	
    if (! xh_readdata(inf,h,seism))
      exit(-1);
    // check header
    if (! xh_checkheader(h))
      exit(-1);
    if (icount == 1) {
      if (strncmp(h.evtcd,"000000A",7) != 0) {
        if (! get_cmt_region(h.evtcd,region) ) {
          fprintf(stderr,"Error in get_cmt_region() ... \n");
          exit(-1);
        }
      }
      // region[23] = '\0';
      fprintf(stdout,"\n---------------------------------------------------------------------\n");
      fprintf(stdout,"XH v%4.2f [%lu bytes]       EVT: %s CMT: %14s",
              h.version,sizeof(h),h.evtcd,h.cmtcd);
      fprintf(stdout,"%8.2f %8.2f %4ldkm",
              h.elat,h.elon,lrint(h.edep));
      fprintf(stdout,"\n%-23s",region);
      fprintf(stdout,"%14d/%02d/%02d %02d:%02d:%05.2f         Mb=%3.1f",
              h.ot.yr,h.ot.mo,h.ot.day,h.ot.hr,h.ot.mn,h.ot.sec,h.Mb);
      fprintf(stdout,"\n---------------------------------------------------------------------\n");
    }

    lat = 'N'; lon = 'E';
    if (h.slat <=0) lat = 'S';
    if (h.slon <=0) lon = 'W';
    // RECORD INFO:
    fprintf(stdout,"%3d %-4s %-2s %-3s %5.2f%c %6.2f%c",
        icount,h.stnm,h.netw,h.chan,fabs(h.slat),lat,fabs(h.slon),lon);
    fprintf(stdout," #= %6d  dt=%5.3f \"%3s\" SENSOR P: %2ld Z: %2ld Amp= %7.1e",
        h.ndata,h.delta,h.wavf,lrint(h.pole[0].r),lrint(h.zero[0].r),
        h.A0*h.DS);  
    fprintf(stdout," Az= %3.0f Inc= %3.0f\n", h.azim,h.incl);  
//  fprintf(stdout,"Values: %8.2e %8.2e %8.2e %8.2e %8.2e\n",
//      seism[0], seism[1], seism[2], seism[3], seism[4]);
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
