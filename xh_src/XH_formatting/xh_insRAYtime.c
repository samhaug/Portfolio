#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"		// XH   structures

// Inserts ray-theoretical traveltime into the XH header
// Phase is on command-line
// Index of h.pcks[] is on the command line

// Generalization of xh_insStime, xh_insSKS, ... etc

main(argc,argv)
int argc;
char *argv[];
{
xhhed h;
int 	icount=1;
int 	i, ierr;
int     i_phase;
int     still_reading_data = 1;
int     index;

float seism[XH_NPTS];
float ray_time;
float td;
float delta,az,baz;

char infile[80];
char phsnm[8];
FILE *ifl, *ofl, *fopen();

int usage();

if(argc != 7) usage();
if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     return(ierr);
}
if ((ofl = fopen(argv[2],"w")) == NULL) {
     ierr = usage();
     return(ierr);
}

index = 2;
while ( ++index < argc && argv[index][0] == '-' ) {
  switch ( argv[index][1] ) {
     case 'p':
        // PHASE name
        if ( sscanf( argv[++index], "%s", phsnm ) != 1) {
            ierr = usage();
        }
        break;
     case 'i':
        // INDEX of h.tpck where the Ray time is placed
        if ( sscanf( argv[++index], "%d", &i_phase ) != 1) {
            ierr = usage();
        }
        break;
     default:
        ierr = usage();
        return(ierr);
  }
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
    fprintf(stderr,"WARNING: make sure event location is defined ...\n");
  }
  // Get backazimuth baz (degrees)
  if (! distaz(h.slat,h.slon,h.elat,h.elon,&delta,&az,&baz))
    exit (-1);
  if (! gettime(h.edep,delta,&ray_time,phsnm))
    exit (-1);
  // ray_time = -999.9 if the ray doesn't exist for given depth/distance)
  if (ray_time > 0.) {
    // Determine StartTime-OriginTime
    if (! xh_TsT0_diff(h,&td) == 1)
    exit (-1);
    h.tpcks[i_phase] = ray_time-td;
  } else {
    h.tpcks[i_phase] = ray_time;
  }

  // STDOUT output
  if (icount == 1) {
    fprintf(stdout,"\n------------------------------------------------------------\n");
    fprintf(stdout,"XH v%4.2f [%ld bytes]   CMT: %s",
            h.version,sizeof(h),h.cmtcd);
    fprintf(stdout,"%8.2f %8.2f %4dkm",
            h.elat,h.elon,(int) rintf(h.edep));
    fprintf(stdout,"%5d/%02d/%02d %02d:%02d:%05.2f         M=%3.1f",
            h.ot.yr,h.ot.mo,h.ot.day,h.ot.hr,h.ot.mn,h.ot.sec,h.Mb);
    fprintf(stdout,"\n------------------------------------------------------------\n");
  }
  fprintf(stdout,"%3d %-4s %-2s %-3s    Gcarc=%8.3f    RAY-time= %8.2f\n\n",
          icount,h.stnm,h.netw,h.chan,delta,h.tpcks[i_phase]);
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

int usage()
        {
        fprintf(stderr,"Usage: xh_insRAYtme in_XHfile out_XHfile -p PHASE -i INDEX\n");
        return(-1);
}
