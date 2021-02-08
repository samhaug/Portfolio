/*
  Prints out the midpoint between sources and receivers
  Need list of earthquake coordinates and list of stations in two separate files
   
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

main(int argc, char *argv[] ){
    float    delta,az,baz;
    float    bcp_lat, bcp_lon;
    int      index = 0;
    int      still_reading_data = 1;
    int      distaz();
    int      ierr;
    float    ev_la,ev_lo,st_la,st_lo;
    FILE     *ifl;

    if (argc != 2){
      ierr = usage();
      exit(ierr);
    }

    if ((ifl = fopen(argv[1],"r")) == NULL) {
       ierr = usage();
       exit(ierr);
    }

    while(!feof(ifl))
    {
      fscanf(ifl, "%f %f %f %f",&ev_la,&ev_lo,&st_la,&st_lo);
      distaz(st_la,st_lo,ev_la,ev_lo,&delta,&az,&baz);
      distaz2latlon(ev_la,ev_lo,delta/2.,az,&bcp_lat,&bcp_lon);
      fprintf(stdout,"%7.2f %8.2f %8.2f %8.2f\n", bcp_lat,bcp_lon,az,delta);
    }
} 

int usage(){
fprintf(stderr,"Usage: source_stat_midpoint IN_FILE\n");
fprintf(stderr,"IN_FILE columns: ev_la ev_lo st_la st_lo\n");
fprintf(stderr,"OUTPUT columns: bcp_la bcp_lo az delta\n");
return(-1);
}

