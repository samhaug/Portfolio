/*
  xh_grepnetw - selects data from XH file
  for specified networks from XH file
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "xhhead.h"

int main( argc, argv )
int   argc;
char       *argv[];
{
    float     seism[XH_NPTS];
    float     seismd[XH_NPTS];
    int       index = 0, i,j,nnetw=0;
    int       still_reading_data = 1;
    int       keep_this_network  = 0;
    int	      ierr;
    xhhed     h;
    char      knetworks[10][6];
    FILE     *ifl, *ofl, *fopen();


if (argc != 3) {
   usage();
   exit(-1);

}
 if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     exit(ierr);
 }
 if ((ofl = fopen(argv[2],"w")) == NULL) {
     ierr = usage();
     exit(ierr);
 }
// Loop over traces on stdin
while (still_reading_data) {
  if    (! xh_readhead(ifl,&h)) {
     exit(-1);
  } else {
     //fprintf(stdout,"%s\n",h.netw);
     if (! xh_readdata(ifl,h,seism))
       exit(-1);
        fprintf(stdout,"%-4s %3s id=%d\n",h.stnm,h.netw,h.chid);
        // WRITE XH header and data
        for (i=0;i<h.ndata;i++){
             seismd[i] = 0;
        }
        if (! xh_writehead(ofl,h))
          exit(-1);
        if (! xh_writedata(ofl,h,seismd))
          exit(-1);
  }
} // while

fclose(ifl);
exit( 0 );
} 

int usage()
{
fprintf(stderr,"Usage: xh_zero in_XH out_XH \n");
return(-1);
}
