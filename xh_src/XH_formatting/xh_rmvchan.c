/*
  xh_rmvstat - removes data for a list of channels from XH file
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
    int       index = 0, j,nchan=0;
    int       still_reading_data = 1;
    int       keep_this_channel  = 0;
    int	      ierr;
    xhhed     h;
    char      kchannels[200][6];
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
 if (strncmp(argv[3],"-c",2) != 0) {
     ierr = usage();
     exit(ierr);
 } else {
     index=4;
     j=0;
     while(index<argc) {
       sprintf(kchannels[j], "%s", argv[index]);
       if (kchannels[j][4] == ' ') kchannels[j][4] = '\0';
       if (kchannels[j][3] == ' ') kchannels[j][3] = '\0';
       index++;
       j++;
     }
     nchan = argc - 4;
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
     keep_this_channel = 1;
     for (j=0;j<nchan;j++) {
       if (strcmp(h.chan,kchannels[j]) == 0) {
          fprintf(stdout,"Eliminating data for %-4s %3s \n",h.stnm,h.chan);
          keep_this_channel = 0;
       } 
     }
     if (keep_this_channel) {
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
fprintf(stderr,"Usage: xh_rmvchan in_XH out_XH -c kchan1 kchan2 ... \n");
return(-1);
}
