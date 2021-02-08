/*
  xh_weight - uses geographical weighting scheme proposed by Ruan et al. (2019)
              to weight array given reference distance in degrees.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <malloc.h>
#include "xhhead.h"

main( argc, argv )
int   argc;
char       *argv[];
{
    float     seism[XH_NPTS];
    float     seism2[XH_NPTS];
    float     delta,az,baz;
    float     ref_dist;
    float     weight;
    int       index = 0;
    int       still_reading_data_1 = 1;
    int       still_reading_data_2 = 1;
    int	      ierr,i;
    xhhed     h,h2;
    FILE     *ifl, *ifl2, *ofl, *fopen();

    int distaz();


 if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     exit(ierr);
 }

 if (argc != 4) {
     ierr = usage();
     exit(ierr);
 }

 ref_dist = atof(argv[3]);
 // open a second file buffer for inner loop
 ifl2 = fopen(argv[1],"r");
 ofl = fopen(argv[2],"w");

// Loop over traces on stdin
while (still_reading_data_1) {
  if (! xh_readhead(ifl,&h)){ 
     still_reading_data_1 = 0;
  }
  else {
     if (! xh_readdata(ifl,h,seism)){
        still_reading_data_1 = 0;
     }
     // Loop over second file buffer to compute weight for each station
     h.flt[0] = 0.0;
     weight = 0.0;
     while (still_reading_data_2){
         if (! xh_readhead(ifl2,&h2)){
             still_reading_data_2 = 0;
         }
         else{
             if (! xh_readdata(ifl2,h2,seism2)){
                 still_reading_data_2 = 0;
             } 
             distaz(h.slat,h.slon,h2.slat,h2.slon,&delta,&az,&baz);
             //delta=3.;
             weight += pow(M_E, -1*pow((delta/ref_dist),2)); 
         }
     }
     for (i=0;i<h.ndata;i++){
         seism[i] *= 1./weight;
     }
     still_reading_data_2 = 1;
     h.flt[0] = 1./weight;
     rewind(ifl2);
  }
  // WRITE XH header and data
  printf("%8.4f %8.4f %8.4f\n",h.slon,h.slat,h.flt[0]);
  if (! xh_writehead(ofl,h)) exit (-1);
  if (! xh_writedata(ofl,h,seism)) exit (-1);
} // while

fclose(ifl);
fclose(ifl2);
} 

int usage()
{
fprintf(stderr,"Usage: xh_weight in_XH out_XH ref_dist\n");
fprintf(stderr,"       ref_dist : reference distance in degrees\n");
fprintf(stderr,"       See equation 23 in Orsvuran et al. (2020)\n");
fprintf(stderr,"       multiplies data by weighting factor\n");
fprintf(stderr,"       stores weighting value in flt[0] of header. \n");
return(-1);
}
