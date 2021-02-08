/*
 * xh_2sac - pick out individual stations from XH file and write out sac files
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "xhhead.h"
#include "time.h"

//#include "xh_functions.h"

int main( argc, argv )
int   argc;
char       *argv[];
{
    float     seism[XH_NPTS];
    int       index = 0, j,nstns=0, itr=0;;
    // outputtype = 1 the SACfiles are called: s0001.sac,s0002.sac,etc ...
    // outputtype = 0 the SACfiles are called: stnam.chan
    int       outputtype = 0;
    int       still_reading_data = 1;
    int	      ierr;
    xhhed     h;
    char      kstations[200][6],sacfile[80];
    FILE     *ifl, *fopen();

    xh_time tt;

if (argc < 4) {
  ierr = usage();
  exit(1);
}
if ((ifl = fopen(argv[1],"r")) == NULL) {
    ierr = usage();
    exit(2);
}
if (strncmp(argv[2],"-s",2) != 0) {
     ierr = usage();
     exit(ierr);
} else {
    index=3;
    j=0;
    while(index<argc) {
      sprintf(kstations[j], "%s", argv[index]);
      index++;
      j++;
    }
    nstns = argc - 3;
}

/* Loop over traces on stdin. */
while (still_reading_data) {
  if    (! xh_readhead(ifl,&h)) {
     exit(1);
  } else {
     if (! xh_readdata(ifl,h,seism))
       exit(2);
     // check header
     if (! xh_checkheader(h))
       exit(6);
     itr++;
     for (j=0;j<nstns;j++) {
         if (strncmp(h.stnm,kstations[j],strlen(kstations[j])) == 0 ||
             strncmp("all",kstations[0],3) == 0) {
           if (outputtype == 0) {
             if (h.stnm[3] == ' ') {
               sprintf(sacfile,"%.2s.%.3s.%.3s",h.netw,h.stnm,h.chan);
             } else if (h.stnm[4] == ' ') {
               sprintf(sacfile,"%.2s.%.4s.%.3s",h.netw,h.stnm,h.chan);
             } else {
               sprintf(sacfile,"%.2s.%.5s.%.3s",h.netw,h.stnm,h.chan);
             }
           } else {
             sprintf(sacfile,"s%04d.sac",itr);
           }
           xh_writesac(h,seism,sacfile);
         }
     }
  }
} // while

fclose(ifl);
exit( 7 );
} 

int usage()
{
fprintf(stderr,"Usage: xh_2sac in_XH -s kstn1 kstn2 ... \n");
fprintf(stderr,"or     xh_2sac in_XH -s all\n");
return(-1);
}

/*
if (strncmp(argv[2],"-s",2) != 0) {
    ierr = usage();
    exit(ierr);
} else {
    index=3;
    j=0;
    while(index<argc) {
      sprintf(kstations[j], "%s", argv[index]);
      index++;
      j++;
    }
    nstns = argc - 3;
}
*/
