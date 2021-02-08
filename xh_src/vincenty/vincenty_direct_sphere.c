#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
/*
    vincenty_direct computes lat/lon given inital lat/lon, az and gcarc

     Samuel Haugland June 2019
*/
int usage();

int main(int argc, char *argv[]){
  double phi1,phi2,lambda1,lambda2,gcarc,s,az,alpha21,alpha12,rad;
  double dist;
  double i;
  int ierr;

  if (argc != 6){
    ierr = usage();
    exit(ierr);
  }
  else{
    phi1    =   atof(argv[1]);
    lambda1 =   atof(argv[2]);
    az      =   atof(argv[3]);
    gcarc   =   atof(argv[4]);
    rad     =   atof(argv[5])*1000.;
  }

  
  dist = gcarc*(3.14159/180.)*rad;
  vincenty_direct_sphere(phi1,lambda1,az,dist,rad,&phi2,&lambda2,&alpha21);
  fprintf(stdout,"%8.3f %8.3f\n",phi2,lambda2);
  return(1);
}

int usage(){
  fprintf(stderr,"\n");
  fprintf(stderr,"   vincenty_direct_sphere computes lat/lon given inital\n");
  fprintf(stderr,"        lat/lon, radius, az and gcarc\n");
  fprintf(stderr,"\n");
  fprintf(stderr,"   Usage: vincenty_direct_sphere lat_1 lon_1 az gcarc rad\n");
  fprintf(stderr,"      Western longitudes are negative\n");
  fprintf(stderr,"\n");
  fprintf(stderr,"   Output: lat_2 lon_2\n");
  fprintf(stderr,"\n");
  return(-1);
}






