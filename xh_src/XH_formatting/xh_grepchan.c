/*
  xh_grepchan - selects data from XH file
  for specified channel from XH file
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "xhhead.h"

//#include "xh_functions.h"

int main( argc, argv )
int   argc;
char       *argv[];
{
    float     seism[XH_NPTS];
    int       index = 0, i,j,nchan=0;
    int       still_reading_data = 1;
    int       keep_this_channel  = 0;
    int	      ierr;
    xhhed     h;
    char      kchannels[10][6];
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
//      fprintf(stdout,"j= %d kchannels= %s\n",j,kchannels[j]);
       index++;
       j++;
     }
     nchan = argc - 4;
 }
} else {
  ierr = usage();
  exit(ierr);
}
//fprintf(stdout,"nchan= %d\n",nchan);

// Loop over traces on stdin
while (still_reading_data) {
  if    (! xh_readhead(ifl,&h)) {
     exit(-1);
  } else {
     if (! xh_readdata(ifl,h,seism))
       exit(-1);
     keep_this_channel = 0;
//   fprintf(stdout,"chan= %s strlen= %d\n",h.chan,strlen(h.chan));
     for (j=0;j<nchan;j++) {
//     fprintf(stdout,"chan= %s %s strlen= %d\n",h.chan,kchannels[j],strlen(kchannels[j]));
       //if (strncmp(h.chan,kchannels[j],strlen(kchannels[j])) == 0)
       if (strncmp(h.chan,kchannels[j],3) == 0)
          keep_this_channel = 1;
     }
     if (keep_this_channel) {
//      fprintf(stdout,"Writing %-4s %3s id=%d\n",h.stnm,h.chan,h.chid);
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
fprintf(stderr,"Usage: xh_grepchan in_XH out_XH -c kchn1 kchn2 ... \n");
return(-1);
}
