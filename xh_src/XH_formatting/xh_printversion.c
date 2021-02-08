#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <sys/param.h>
#include "xhhead.h"	/* XH format structures */

// Reads the header of an XH file and prints out its version


main(argc,argv)
int argc;
char *argv[];
{
xhhed 	h;
int 	icount=1;
int 	i, ierr;

int still_reading_data = 1;


char infile[80];
FILE *inf, *fopen();

int usage();

if ((inf = fopen(argv[1],"r")) == NULL) {
   ierr = usage(argv[1]);
   return(ierr);
}

// only for first header line
if   (! xh_readhead(inf,&h)) {
  still_reading_data = 0;
  exit(-1);
}

fprintf(stdout,"xh%4.2f\n", h.version);

fclose (inf);
fflush(stdout);
}

int usage()
{
fprintf(stderr,"\n");
fprintf(stderr,"Usage: xh_printversion XH-file\n");
fprintf(stderr,"       prints version of XH header (from the first header line)\n");
fprintf(stderr,"\n");
return(-1);
}
