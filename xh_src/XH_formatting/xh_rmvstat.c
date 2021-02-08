/*
  xh_rmvstat - removes data for a list of stations from XH file
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <malloc.h>
#include "xhhead.h"
#include "time.h"

main( argc, argv )
int   argc;
char       *argv[];
{
    float     seism[XH_NPTS];
    int       index = 0, j,nstns=0;
    int       still_reading_data = 1;
    int       keep_this_station  = 0;
    int	      ierr;
    xhhed     h;
    char      kstations[200][6],sacfile[80];
    FILE     *ifl, *ofl, *fopen();

    xh_time tt;

if (argc > 4) {
 if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     exit(ierr);
 }
 if ((ofl = fopen(argv[2],"w")) == NULL) {
     ierr = usage();
     exit(ierr);
 }
 if (strncmp(argv[3],"-s",2) != 0) {
     ierr = usage();
     exit(ierr);
 } else {
     index=4;
     j=0;
     while(index<argc) {
       sprintf(kstations[j], "%s", argv[index]);
       index++;
       j++;
     }
     nstns = argc - 4;
 }
} else {
  ierr = usage();
  exit(ierr);
}

// Loop over traces on stdin
while (still_reading_data) {
  if    (! xh_readhead(ifl,&h)) {
     exit(-1);
  } else {
     if (! xh_readdata(ifl,h,seism))
       exit(-1);
     keep_this_station = 1;
     for (j=0;j<nstns;j++) {
       if (strncmp(h.stnm,kstations[j],strlen(kstations[j])) == 0) {
          fprintf(stdout,"Eliminating data for %-4s %3s \n",h.stnm,h.chan);
          keep_this_station = 0;
       } 
     }
     if (keep_this_station) {
        fprintf(stdout,"Writing data for %-4s %3s \n",h.stnm,h.chan);
        // WRITE XH header and data
        if (! xh_writehead(ofl,h))
          exit(-1);
        if (! xh_writedata(ofl,h,seism))
          exit(-1);
     }
  }
} // while

fclose(ifl);
exit( 0 );
} 

int usage()
{
fprintf(stderr,"Usage: xh_rmvstat in_XH out_XH -s kstn1 kstn2 ... \n");
return(-1);
}
