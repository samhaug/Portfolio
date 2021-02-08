/*
 * xh_2rec - pick out individual stations from XH file
             and write out XY files + header
 *
 */

#include <stdio.h>
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
    char      kstations[200][6],drecfile[80],hrecfile[80];
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
          if (h.stnm[3] == ' ') {
            sprintf(drecfile,"%7s.%.3s.%.3s.xy",h.cmtcd,h.stnm,h.chan);
            sprintf(hrecfile,"%7s.%.3s.%.3s.hed",h.cmtcd,h.stnm,h.chan);
          } else {
            sprintf(drecfile,"%7s.%.4s.%.3s.xy",h.cmtcd,h.stnm,h.chan);
            sprintf(hrecfile,"%7s.%.4s.%.3s.hed",h.cmtcd,h.stnm,h.chan);
          }
          xh_writerec(h,seism,drecfile,hrecfile);
       }
     }
  }
} // while

fclose(ifl);
exit( 0 );
} 

int usage()
{
fprintf(stderr,"Usage: xh_2rec in_XH -s kstn1 kstn2 ... \n");
fprintf(stderr,"or     xh_2rec in_XH -s all\n");
return(-1);
}
