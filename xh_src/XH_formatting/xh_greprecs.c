/*
  xh_greprecs - selects records num_1 through num_2
  from XH file from XH file
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "xhhead.h"

// #include "xh_functions.h"

int main( argc, argv )
int   argc;
char       *argv[];
{
    float     seism[XH_NPTS];
    int       index = 0, i,j,nstns=0;
    int       still_reading_data = 1;
    int       i_record = 0;
    int       num_1, num_2;
    int	      ierr;
    xhhed     h;
    FILE     *ifl, *ofl, *fopen();

if (argc > 4) {
 if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     exit(ierr);
 }
 if ((ofl = fopen(argv[2],"w")) == NULL) {
     ierr = usage();
     exit(ierr);
 }
 if (strncmp(argv[3],"-d",2) != 0) {
     ierr = usage();
     exit(ierr);
 } else {
     sscanf(argv[4],"%d", &num_1);
     sscanf(argv[5],"%d", &num_2);
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
     
     i_record = i_record + 1;
     if (i_record >= num_1 && i_record <= num_2) {
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
fprintf(stderr,"Usage: xh_greprecs in_XH out_XH -d RecNum_1 RecNum_2\n");
return(-1);
}
