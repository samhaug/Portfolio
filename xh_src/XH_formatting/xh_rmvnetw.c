/*
  xh_rmvnetw - removes data for a list of networks
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
    int       index = 0, j,nnetw=0;
    int       still_reading_data = 1;
    int       keep_this_network  = 0;
    int	      ierr;
    xhhed     h;
    char      knetworks[200][6];
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
 if (strncmp(argv[3],"-n",2) != 0) {
     ierr = usage();
     exit(ierr);
 } else {
     index=4;
     j=0;
     while(index<argc) {
       sprintf(knetworks[j], "%s", argv[index]);
       if (knetworks[j][4] == ' ') knetworks[j][4] = '\0';
       if (knetworks[j][3] == ' ') knetworks[j][3] = '\0';
       if (knetworks[j][2] == ' ') knetworks[j][2] = '\0';
       if (knetworks[j][1] == ' ') knetworks[j][1] = '\0';
       index++;
       j++;
     }
     nnetw = argc - 4;
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
     keep_this_network = 1;
     for (j=0;j<nnetw;j++) {
       if (strcmp(h.netw,knetworks[j]) == 0) {
//        fprintf(stdout,"Eliminating data for %-4s %3s \n",h.stnm,h.netw);
          keep_this_network = 0;
       } 
     }
     if (keep_this_network) {
//      fprintf(stdout,"Writing data for %-4s %3s \n",h.stnm,h.netw);
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
fprintf(stderr,"Usage: xh_rmvnetw in_XH out_XH -n knetw1 knetw2 ... \n");
return(-1);
}
