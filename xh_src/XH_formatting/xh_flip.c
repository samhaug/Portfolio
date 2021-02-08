/*
  xh_flip - multiples the traces by h.tpcks[4]
  which is -1 or +1 and produced by the code xh_PPalignment
*/

#include <stdio.h>
#include <string.h>
#include <math.h>
#include "xhhead.h"

main( argc, argv )
int   argc;
char  *argv[];
{
    float     seism[XH_NPTS];
    int       index = 0, i,j;
    int       still_reading_data = 1;
    int	      ierr;
    xhhed     h;
    FILE      *ifl, *ofl, *fopen();

if (argc == 3) {
 if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     exit(ierr);
 }
 if ((ofl = fopen(argv[2],"w")) == NULL) {
     ierr = usage();
     exit(ierr);
 }
} else {
  ierr = usage();
  exit(ierr);
}

// Loop over traces on stdin
while (still_reading_data){
  if (! xh_readhead(ifl,&h)){
     exit(-1);
  } else {
     if (! xh_readdata(ifl,h,seism))
       exit(-1);
     if ( fabs(h.tpcks[4]) == 1.0 ) {
       for(i=0; i<h.ndata; i++) 
          seism[i] = seism[i] * h.tpcks[4];
       fprintf(stdout,"Writing %s %-4s FLIP=%3.0f\n",h.netw,h.stnm,h.tpcks[4]);
       if (! xh_writehead(ofl,h))
         exit(-1);
       if (! xh_writedata(ofl,h,seism))
         exit(-1);
     } else {
       fprintf(stderr,"PCKS_4 for %s/%s = %f\n",h.netw,h.stnm,h.tpcks[4]);
     }
  }
} // while

fclose(ifl);
exit( 0 );
} 

int usage()
{
fprintf(stderr,"Usage: xh_flip in_XH out_XH\n");
return(-1);
}
