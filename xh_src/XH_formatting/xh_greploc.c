/*
  xh_greploc - selects data from XH file
  for specified location codes from XH file
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "xhhead.h"

int main( argc, argv )
int   argc;
char  *argv[];
{
    float     seism[XH_NPTS];
    int       index = 0, i,j,nloc=0;
    int       still_reading_data = 1;
    int       keep_this_location = 0;
    int	      ierr;
    xhhed     h;
    char      knetworks[10][6];
    int       klocs[4];
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
 if (strncmp(argv[3],"-l",2) != 0) {
     ierr = usage();
     exit(ierr);
 } 
 else {
     index=4;
     j=0;
     while(index<argc) {
        //sprintf(knetworks[j], "%s", argv[index]);
        klocs[j] = atoi(argv[index]);
        index++;
        j++;
     }
     nloc = argc - 4;
 }
} 
 else {
    ierr = usage();
    exit(ierr);
}

// Loop over traces on stdin
while (still_reading_data) {
  if (! xh_readhead(ifl,&h)){ 
      exit(-1);
  }
  else {
     //fprintf(stdout,"%s\n",h.netw);
     if (! xh_readdata(ifl,h,seism)){
        exit(-1);
     }
     keep_this_location = 0;
     for (j=0;j<nloc;j++){
        if (h.locc == klocs[j]){
           keep_this_location = 1;
        }
     }
     if (keep_this_location) {
        fprintf(stdout,"%-4s %3s id=%d loc=%d\n",h.stnm,h.netw,h.chid,h.locc);
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

int usage(){
    fprintf(stderr,"Usage: xh_greploc in_XH out_XH -l loc1 loc2 ... \n");
    return(-1);
}
