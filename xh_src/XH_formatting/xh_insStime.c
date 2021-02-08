#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"		// XH   structures

// Inserts S-wave traveltime into the XH header

main(argc,argv)
int argc;
char *argv[];
{
xhhed 	h;
int 	icount=1;
int 	i, ierr;

int still_reading_data = 1;
float seism[XH_NPTS];
float Stime;
float td;
float delta,az,baz;

char infile[80];
char region[23];
FILE *ifl, *ofl, *fopen();

int usage();

if(argc != 3) usage("");
if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage(argv[1]);
     return(ierr);
}
if ((ofl = fopen(argv[2],"w")) == NULL) {
     ierr = usage(argv[2]);
     return(ierr);
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

  if (h.elat == 0 && h.elon == 0.) {
    fprintf(stderr,"ERROR event location is not defined ...\n");
    exit (-1);
  }
  // Get backazimuth baz (degrees)
  if (! distaz(h.slat,h.slon,h.elat,h.elon,&delta,&az,&baz))
    exit (-1);
  // Get Swave traveltime for depth and distance from TravelTimeTables
  if (! gettime(h.edep,delta,&Stime,"S"))
    exit (-1);
  // Determine StartTime-OriginTime
  if (! xh_TsT0_diff(h,&td) == 1)
    exit (-1);
  // Put Stime in XH-header
  h.tpcks[5] = Stime-td;

  // STDOUT output
  if (icount == 1) {
    if (! get_cmt_region(h.evtcd,region) ) {
      fprintf(stderr,"Cannot extract event region\n");
      exit(-1);
    }
    fprintf(stdout,"\n------------------------------------------------------------\n");
    fprintf(stdout,"XH v%4.2f [%d bytes]   CMT: %s",
            h.version,sizeof(h),h.evtcd);
    fprintf(stdout,"%8.2f %8.2f %4dkm",
            h.elat,h.elon,(int) rintf(h.edep));
    fprintf(stdout,"\n%-23s",region);
    fprintf(stdout,"%5d/%02d/%02d %02d:%02d:%05.2f         M=%3.1f",
            h.ot.yr,h.ot.mo,h.ot.day,h.ot.hr,h.ot.mn,h.ot.sec,h.Mb);
    fprintf(stdout,"\n------------------------------------------------------------\n");
  }
  fprintf(stdout,"%3d %-4s %-2s %-3s    Gcarc=%8.3f    S-time= %8.2f\n",
          icount,h.stnm,h.netw,h.chan,delta,Stime);
  icount++;
  // WRITE XH header and data
  if (! xh_writehead(ofl,h))
    exit (-1);
  if (! xh_writedata(ofl,h,seism)) 
    exit (-1);
} // while

fclose (ifl);
fclose (ofl);
}

int usage(flnm)
char *flnm;
        {
        fprintf(stderr,"Usage: xh_insStme in_XHfile out_XHfile\n");
        return(-1);
}
