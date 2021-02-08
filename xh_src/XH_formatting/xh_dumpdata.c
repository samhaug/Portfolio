#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <sys/param.h>
#include "xhhead.h"	/* XH format structures */

/* Reads the header of an XH file and prints out some information */
/* xh_longhead FILE */

main(argc,argv)
int argc;
char *argv[];
{
xhhed 	h;
int 	icount=1;
int 	i, ierr;

int still_reading_data = 1;
float seism[XH_NPTS];

float     delta,az,baz;
float     uuu;


char infile[80];
char lat, lon;
char region[23];
FILE *inf, *fopen();

int usage();
int distaz();

if ((inf = fopen(argv[1],"r")) == NULL) {
   ierr = usage(argv[1]);
   return(ierr);
}

while (still_reading_data) {
  if   (! xh_readhead(inf,&h)) {
    still_reading_data = 0;
    exit(-1);
  } 
  else {	
    if (! xh_readdata(inf,h,seism)) {
      still_reading_data = 0;
      exit(-1);
    }
    // check header
    if (! xh_checkheader(h) )
      exit(-1);

    if (! starttime(h,&uuu))
      fprintf(stderr,"Error in starttime() ...\n");
    // Get distance (degrees)
    if (! distaz(h.slat,h.slon,h.elat,h.elon,&delta,&az,&baz))
      exit(-1) ;

    lat = 'N'; lon = 'E';
    if (h.slat <=0) lat = 'S';
    if (h.slon <=0) lon = 'W';
    // STDOUT
    fprintf(stdout,"%-3d ", icount);
    fprintf(stdout,"xh%4.2f ", h.version);
    fprintf(stdout,"%s %3.0fkm %-6s %2d %-2s %-3s %d ",
           h.evtcd,h.edep,h.stnm,h.locc,h.netw,h.chan,h.chid);
  //fprintf(stdout,"azim= %3.0f incl= %3.0f ", h.azim,h.incl);
    fprintf(stdout,"%6.2f %7.2f ",
           h.slat,h.slon);
    //fprintf(stdout,"%6.2f%c %7.2f%c ",
    //       fabsf(h.slat),lat,fabsf(h.slon),lon);
    fprintf(stdout,"TS: %04d/%02d/%02d ", h.tstart.yr, h.tstart.mo, h.tstart.day);
    fprintf(stdout,"%02d:%02d:%5.2f  ",   h.tstart.hr, h.tstart.mn, h.tstart.sec);
    fprintf(stdout,"OT: %04d/%02d/%02d ", h.ot.yr, h.ot.mo, h.ot.day);
    fprintf(stdout,"%02d:%02d:%5.2f  ",   h.ot.hr, h.ot.mn, h.ot.sec);
    fprintf(stdout," %5.2f ", delta);
    fprintf(stdout," %6.2f ", az);
    fprintf(stdout,"%7d %7.3f %s %d ",
           h.ndata,h.delta,h.wavf,h.qual);
 // fprintf(stdout,"DS= %9.2e A0= %9.2e ", h.DS,h.A0);  
 // fprintf(stdout,"%d/%d ", (int) h.pole[0].r, (int) h.zero[0].r);  
 // fprintf(stdout,"SStime= %6.1f ",  h.tpcks[4]);
 // fprintf(stdout,"Handpck= %6.1f ", h.tpcks[2]);
 // fprintf(stdout,"Shift= %5.2f ",   h.tpcks[6]);
 // fprintf(stdout,"Flip= %4.1f ",    h.tpcks[4]);
 // fprintf(stdout,"AMP= %5.3f Pol= %2.0f", h.tpcks[7],h.tpcks[8]);
 // fprintf(stdout,"%7.1e ",
 //        h.A0*h.DS);  
 // fprintf(stdout," Sample 449 = %5.3f",seism[449]);  
 // fprintf(stdout," Sample 1000 = %9.2e",seism[1000]);  
 // fprintf(stdout," Sample 451 = %5.3f",seism[451]);  
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
