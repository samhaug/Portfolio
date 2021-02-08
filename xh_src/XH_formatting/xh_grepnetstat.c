/*
  xh_grepnetw - selects data from XH file
  for specified networks from XH file
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "xhhead.h"

int main( int argc, char *argv[] ){
    float     seism[XH_NPTS];
    double    lat, lon;
    int       index = 0, i,j,nnetw=0;
    int       still_reading_data = 1;
    int       keep_this_network  = 0;
    int	      ierr;
    xhhed     h;
    char      knetworks[10][6];
    char      netw[CHARSIZE];
    char      stat[CHARSIZE];
    FILE     *ifl, *ofl, *fopen(), *coord;

if (argc != 4) {
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
 if ((coord = fopen(argv[3],"r")) == NULL) {
     ierr = usage();
     exit(ierr);
 }

while (!feof(coord)){
   fscanf(coord,"%lf %lf %s %s\n", &lat, &lon, netw, stat);
   //printf("%lf %lf %s %s\n", lat, lon, netw, stat);
   // Loop over traces on stdin
   still_reading_data=1;
   while (still_reading_data) {
     if (! xh_readhead(ifl,&h)) still_reading_data=0;
     else {
        if (! xh_readdata(ifl,h,seism)) still_reading_data=0;

        // If the station and network match, write it out
        if ( (strncmp(h.netw,netw,2) == 0) && (strncmp(h.stnm,stat,4) == 0) ){
           //fprintf(stdout,"%-4s %3s id=%d\n",h.stnm,h.netw,h.chid);
           // WRITE XH header and data
           if (! xh_writehead(ofl,h)) exit(-1);
           if (! xh_writedata(ofl,h,seism)) exit(-1);
        }
     } //else
   } // while infile
   rewind(ifl);
} // while coord
   
fclose(ifl);
fclose(coord);
exit(0);
} 

int usage(){
fprintf(stderr,"Usage: xh_grepnetstat in_XH out_XH coord_file \n");
fprintf(stderr," coord_file is a four column ascii file of the form\n");
fprintf(stderr," LAT LON NET STAT\n");
fprintf(stderr," xh_grepnetstat will only write traces that match NET and STAT\n");
return(-1);
}
