#include <stdio.h>
#include <string.h>
#include <stdlib.h>
/*
    vincenty_direct computes lat/lon given inital lat/lon, az and gcarc

     Samuel Haugland June 2019
*/
int usage();

int main(int argc, char *argv[]){
  double phi1,phi2,lambda1,lambda2,gcarc,s,az,alpha21,alpha12;
  double i;
  int ierr;

  if (argc != 5){
    ierr = usage();
    exit(ierr);
  }
  else{
    phi1    =   atof(argv[1]);
    lambda1 =   atof(argv[2]);
    az      =   atof(argv[3]);
    gcarc   =   atof(argv[4]);
  }

  vincenty_direct(phi1,lambda1,az,gcarc*111195.,&phi2,&lambda2,&alpha21);
  fprintf(stdout,"%8.3f %8.3f\n",phi2,lambda2);
  return(1);
}

int usage(){
  fprintf(stderr,"\n");
  fprintf(stderr,"   vincenty_direct computes lat/lon given inital lat/lon, az and gcarc\n");
  fprintf(stderr,"\n");
  fprintf(stderr,"   Usage: vincenty_direct lat_1 lon_1 az gcarc\n");
  fprintf(stderr,"      Western longitudes are negative\n");
  fprintf(stderr,"\n");
  fprintf(stderr,"   Output: lat_2 lon_2\n");
  fprintf(stderr,"\n");
  return(-1);
}






