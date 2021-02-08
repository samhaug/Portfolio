#include <stdio.h>
#include <math.h>
#include <stdlib.h>
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
    still_reading_data = 0;
    exit(-1);
  } else {	
    if (! xh_readdata(inf,h,seism)) {
      still_reading_data = 0;
      exit(-1);
    }
    // check header
    if (! xh_checkheader(h) )
      exit(-1);

   // Get distance (degrees)
   if (! distaz(h.slat,h.slon,h.elat,h.elon,&delta,&az,&baz))
       exit(-1) ;

    lat = 'N'; lon = 'E';
    if (h.slat <=0) lat = 'S';
    if (h.slon <=0) lon = 'W';
    // STDOUT
    fprintf(stdout,"%-3d ", icount);
    fprintf(stdout,"%s %3.0f km %-4s %-2s %-3s ",
           h.evtcd,h.edep,h.stnm,h.netw,h.chan);
    fprintf(stdout,"%6.2f %7.2f ", h.slat,h.slon);
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
