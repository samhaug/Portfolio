/*
  xh_mult - multiples the traces by h.tpcks[4]
  which is -1 or +1 and produced by the code xh_PPalignment
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "xhhead.h"

main( argc, argv )
int   argc;
char       *argv[];
{
    float     seism[XH_NPTS], fac;
    int       index = 0, i,j;
    int       still_reading_data = 1;
    int	      ierr;
    xhhed     h;
    FILE     *ifl, *ofl, *fopen();

if (argc == 5) {
 if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     exit(ierr);
 }
 if ((ofl = fopen(argv[2],"w")) == NULL) {
     ierr = usage();
     exit(ierr);
 }
 if (strncmp(argv[3],"-x",2) != 0) {
     ierr = usage();
     exit(ierr);
 } else {
   fac = atoi(argv[4]);
 }
} else {
  ierr = usage();
  exit(ierr);
}

while (still_reading_data) {
  if    (! xh_readhead(ifl,&h)) {
     exit(-1);
  } else {
     if (! xh_readdata(ifl,h,seism))
       exit(-1);
     for(i=0; i<h.ndata; i++)
        seism[i] = seism[i] * fac;
     if (! xh_writehead(ofl,h))
       exit(-1);
     if (! xh_writedata(ofl,h,seism))
       exit(-1);
  }
} // while


fclose(ifl);
exit( 0 );
} 

int usage()
{
fprintf(stderr,"Usage: xh_mult in_XH out_XH -x FAC\n");
return(-1);
}
