#include <stdio.h>
#include <string.h>
#include <stdlib.h>
/*
    vincenty_invserse computes gcarc, az, and baz from input coordinates

     Samuel Haugland June 2019
*/
int usage();

int main(int argc, char *argv[]){
  double phi1,phi2,lambda1,lambda2,gcarc,s,az,alpha21,alpha12;
  double eq_lat,eq_lon,st_lat,st_lon;
  double i;
  int ierr;

  if (argc != 5){
    ierr = usage();
    exit(ierr);
  }
  else{
    eq_lat    =   atof(argv[1]);
    eq_lon    =   atof(argv[2]);
    st_lat    =   atof(argv[3]);
    st_lon    =   atof(argv[4]);
  }
  vincenty_inverse(eq_lat,eq_lon,st_lat,st_lon,&alpha12,&alpha21,&gcarc);
  if (alpha12 < 0){
     alpha12 += 360;
  }
  fprintf(stdout,"%8.3f %8.3f %8.3f\n",alpha12,alpha21,gcarc/111195.0);

  return(1);
}

int usage(){
  fprintf(stderr,"\n");
  fprintf(stderr,"   vincenty_inverse computes az, baz, and gcarc given input coord pair\n");
  fprintf(stderr,"\n");
  fprintf(stderr,"   Usage: vincenty_inverse lat_1 lon_1 lat_2 lon_2\n");
  fprintf(stderr,"      Western longitudes are negative\n");
  fprintf(stderr,"\n");
  fprintf(stderr,"   Output: az, baz, gcarc (deg) \n");
  fprintf(stderr,"\n");
  return(-1);
}






