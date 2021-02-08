#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"	/* XH format structures */

/* Reads the header of an XH file and prints out some information */
/* xh_shorthead FILE */

int main(argc,argv)
int argc;
char *argv[];
{
xhhed 	h;
int 	icount=1;
int 	i, ierr;

int still_reading_data = 1;
float seism[XH_NPTS];

float     gcarc,az,baz;


char infile[80];
char lat, lon;
char region[23];
FILE *inf, *fopen();

int usage();
int distaz();
int xh_readhead();
int xh_readdata();
int xh_checkheader();

if ((inf = fopen(argv[1],"r")) == NULL) {
   ierr = usage(argv[1]);
   return(ierr);
}

while (still_reading_data) {
  if   (! xh_readhead(inf,&h)) {
    still_reading_data = 0;
    exit(1);
  } else {	
    if (! xh_readdata(inf,h,seism)) {
      still_reading_data = 0;
      exit(1);
    }
    // check header
    if (! xh_checkheader(h) )
      exit(-1);

   // Get distance (degrees)
   if (! distaz(h.slat,h.slon,h.elat,h.elon,&gcarc,&az,&baz))
       exit(-1) ;

    lat = 'N'; lon = 'E';
    if (h.slat <=0) lat = 'S';
    if (h.slon <=0) lon = 'W';
    // STDOUT
    fprintf(stdout,"%5f %5d %5d \n",
           h.version,h.nhdr,h.i12345678);
//  fprintf(stdout," %d/%d/%d ",
//         h.ot.yr,h.ot.mo,h.ot.day);
//  fprintf(stdout," %02d:%02d:%04.1f ",
//         h.ot.hr,h.ot.mn,h.ot.sec);
//  fprintf(stdout," %d/%d/%d ",
//         h.tstart.yr,h.tstart.mo,h.tstart.day);
//  fprintf(stdout," %02d:%02d:%04.1f ",
//         h.tstart.hr,h.tstart.mn,h.tstart.sec);
//    fprintf(stdout,"EVT: %5.2f %6.2f ", fabs(h.elat),fabs(h.elon));
//    fprintf(stdout,"STA: %5.2f%c %6.2f%c ", fabs(h.slat),lat,fabs(h.slon),lon);
//    fprintf(stdout," D= %5.1f ", gcarc);
//    fprintf(stdout," A= %5.1f ", az);
//    fprintf(stdout," %d ", h.ndata);
//  fprintf(stdout," %4.2f ", h.delta);
//  fprintf(stdout," %s ", h.wavf);
//  fprintf(stdout," %d ", h.qual);
//  fprintf(stdout,"FLT= %7.1f ", h.flt[0]);
//  fprintf(stdout,"W= %5.1f--%5.1f ",
//         h.tpcks[1],h.tpcks[2]);
//  fprintf(stdout,"T9= %6.1f ", h.tpcks[9]);
//  fprintf(stdout,"T1= %7.1f ", h.tpcks[1]);
//  fprintf(stdout,"T2= %7.1f ", h.tpcks[4]);
//  fprintf(stdout,"AMP= %5.3f Pol= %2.0f", h.tpcks[7],h.tpcks[8]);
//  fprintf(stdout," Sample 9 = %e",seism[9]);  
//    fprintf(stdout,"\n");  
//    icount++;
  }
} // while

fclose (inf);
//fflush(stdout);
}

int usage(flnm)
char *flnm;
{
   fprintf(stderr,"Cannot read XH file: %s\n",flnm);
   return(-1);
}
