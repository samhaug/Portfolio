#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <sys/param.h>
#include "/home/jeroen/inc/xhhead.h"	/* XH format structures */

// Reads the header of an XH file and prints out the quality factor
// xh_printqual in_XH


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
FILE *inf, *fopen();

int usage();

if ((inf = fopen(argv[1],"r")) == NULL) {
   ierr = usage();
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

    fprintf(stdout,"%-3d xh%4.2f %7s %-4s %-2s %-3s ",
           icount,h.version,h.cmtcd,h.stnm,h.netw,h.chan);
    fprintf(stdout,"Q= %d\n", h.qual);
    icount++;
  }
} // while

fclose (inf);
fflush(stdout);
}

int usage()
{
fprintf(stderr,"Usage: xh_printqual in_XH\n");
return(-1);
}
