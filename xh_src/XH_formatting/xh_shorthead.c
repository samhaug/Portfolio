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

float gcarc,az,baz;

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
    //fprintf(stdout,"num evdp   stnm   chan  elat  elon  slat   slon   gcarc  baz   ndata\n");  

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
    fprintf(stdout,"%5d %3.0fkm %-5s %-5s %3s ",
           icount,h.edep,h.netw,h.stnm,h.chan);
    fprintf(stdout,"%5.2f %6.2f ", h.elat,h.elon);
    fprintf(stdout,"%5.2f %6.2f ", h.slat,h.slon);
    fprintf(stdout,"%5.1f ", gcarc);
    fprintf(stdout,"%5.1f ", baz);
    fprintf(stdout," %d ", h.ndata);
    fprintf(stdout,"\n");  
    icount++;
  }
} // while

fclose (inf);
//fflush(stdout);
}

int usage(flnm)
char *flnm;
{
fprintf(stderr,"Cannot read XH file: %s\n",flnm);
fprintf(stdout,"OUTPUT: num  evdp   stnm   chan  elat  elon  slat   slon   gcarc  baz   ndata\n");  
return(-1);
}
