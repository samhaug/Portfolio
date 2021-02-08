/*
 * xh_2asc - pick out individual stations from XH file and write out XY files
 *
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
    int	      ierr;
    xhhed     h;
    char      kstations[200][6],ascfile[80];
    FILE     *ifl, *fopen();

    xh_time tt;

if (argc > 3) {
 if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     exit(ierr);
 }
 if (strncmp(argv[2],"-s",2) != 0) {
     ierr = usage();
     exit(ierr);
 } else {
     index=3;
     j=0;
     while(index<argc) {
       sprintf(kstations[j], "%s", argv[index]);
       if (kstations[j][4] == ' ') kstations[j][4] = '\0';
       if (kstations[j][3] == ' ') kstations[j][3] = '\0';
       index++;
       j++;
     }
     nstns = argc - 3;
 }
} else {
  ierr = usage();
  exit(ierr);
}

/* Loop over traces on stdin. */
while (still_reading_data) {
  if    (! xh_readhead(ifl,&h)) {
     exit(-1);
  } else {
     if (! xh_readdata(ifl,h,seism))
       exit(-1);
     // check header
     if (! xh_checkheader(h))
       exit(-1);
     for (j=0;j<nstns;j++) {
       if (strncmp(h.stnm,kstations[j],4) == 0 ||
           strncmp("all",kstations[0],3) == 0) {
          if (h.stnm[3] == ' ') 
            sprintf(ascfile,"%.3s.%.3s.xy",h.stnm,h.chan);
          else
            sprintf(ascfile,"%.4s.%.3s.xy",h.stnm,h.chan);
          xh_writeasc(h,seism,ascfile);
       }
     }
  }
} // while

fclose(ifl);
exit( 0 );
} 

int usage()
{
fprintf(stderr,"Usage: xh_2asc in_XH -s kstn1 kstn2 ... \n");
fprintf(stderr,"or     xh_2asc in_XH -s all\n");
return(-1);
}
