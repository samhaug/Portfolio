#include <stdio.h>
#include <string.h>
#include <stdlib.h>
/*
     az_spread creates list of stations GCARC degrees away from (LAT/LON)\n");

     between AZ_MIN and AZ_MAX in AZ_INC increment\n");

     Usage: az_spread LAT LON GCARC AZ_MIN AZ_MAX AZ_INC\n");

     Output: three columns: lat,lon,az,baz\n");

     Samuel Haugland April 2019
*/
int usage();

int main(int argc, char *argv[]){
  double lat1,lon1,gcarc,az_min,az_max,az_inc;
  double lat2,lon2,alpha21;
  double i;
  int ierr;

  if (argc != 7){
    ierr = usage();
    exit(ierr);
  }
  else{
    lat1 =   atof(argv[1]);
    lon1 =   atof(argv[2]);
    gcarc =  atof(argv[3])*111195.0;
    az_min = atof(argv[4]);
    az_max = atof(argv[5]);
    az_inc = atof(argv[6]);
  }

  if (az_max <= az_min){
    fprintf(stderr,"AZ_MAX must be greater than AZ_MIN\n");
    exit(-1);
  }

  for (i=az_min;i<=az_max;i+=az_inc){
    vincenty_direct(lat1,lon1,i,gcarc,&lat2,&lon2,&alpha21);
    fprintf(stdout,"%8.3f %8.3f %8.3f %8.3f\n",lat2,lon2,gcarc/111195.0,i,alpha21);
  }
  return(1);
}

int usage(){
  fprintf(stderr,"\n");
  fprintf(stderr,"   az_spread creates list of stations GCARC degrees away from (LAT/LON)\n");
  fprintf(stderr,"   between AZ_MIN and AZ_MAX in AZ_INC increment\n");
  fprintf(stderr,"\n");
  fprintf(stderr,"   Usage: az_spread LAT LON GCARC AZ_MIN AZ_MAX AZ_INC\n");
  fprintf(stderr,"\n");
  fprintf(stderr,"   Output: three columns: lat,lon,gcarc,az,baz\n");
  fprintf(stderr,"\n");
  return(-1);
}






