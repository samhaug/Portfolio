#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "xhhead.h"	/* XH format structures */

/*prints out weights and coordinates */
/* xh_weightshow FILE */

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

while (still_reading_data) {
  if   (! xh_readhead(inf,&h)) {
    still_reading_data = 0;
    exit(1);
  } 
  else {	
    if (! xh_readdata(inf,h,seism)) {
      still_reading_data = 0;
      exit(1);
    }
    // check header
    if (! xh_checkheader(h) )
      exit(-1);
    // STDOUT
    fprintf(stdout,"%8.4f %8.4f %8.4f\n",h.slon,h.slat,h.flt[0]);
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
return(-1);
}
