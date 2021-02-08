/*
 * Prints count map of bouncepoints in lon/lat bins.
   
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

main(int argc, char *argv[] ){
    float    delta,baz;
    float    bcp_lat, bcp_lon;
    int      index = 0;
    int      still_reading_data = 1;
    int      distaz();
    int      ierr;
    float    lat,lon,az,gcarc;
    int       ilat,ilon;
    int      flat,flon;
    FILE     *ifl;
    static int      coord[180][360] = {{0}};
    int      i,j;

    if (argc != 2){
      ierr = usage();
      exit(ierr);
    }

    if ((ifl = fopen(argv[1],"r")) == NULL) {
       ierr = usage();
       exit(ierr);
    }

    // gcarc ranges for sdiff and scs
    //awk '(($4>2 && $4<31) || ($4>52 && $4<70)) {print}' midpoint.dat > scs_midpoint.dat
    //awk '($4>80 && $4<160) {print}' sdiff_midpoint.dat
    while(!feof(ifl))
    {
      fscanf(ifl, "%f %f %f %f",&lat,&lon,&az,&gcarc);
      flat = 90-(int)floor(lat);
      flon = (int)floor(lon);
      if (flon <= 0){
          flon = 180-flon;
      }
      if (gcarc < 160){
      //if ((gcarc > 2 && gcarc < 31) || (gcarc > 52 && gcarc < 70)){
      coord[flat][flon] += 1;
      }
    }

    for (i=0;i<=180;i++){
      for (j=0;j<=360;j++){
          ilat = 90-i;
          ilon = j;
          if (j >= 180){
             ilon = 180-j;
          }
          fprintf(stdout,"%d %d %d \n",ilat,ilon,coord[i][j]);
      }
    }
} 

int usage(){
fprintf(stderr,"Usage: bin_midpoint IN_FILE\n");
fprintf(stderr,"IN_FILE columns: lat lon az gcarc\n");
fprintf(stderr,"OUTPUT columns: lat_bin lon_bin count gcarc\n");
return(-1);
}

