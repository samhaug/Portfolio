#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/*
     gc_spread creates list of stations with the same azimuth AZ from (LAT/LON)

     between GC_MIN and GC_MAX in GC_INC increment

     Usage: gc_spread LAT LON AZ GC_MIN GC_MAX GC_INC

     Output: three columns: lat,lon,az,baz

     Samuel Haugland April 2019
*/

int usage();

int main(int argc, char *argv[]){
  double lat1,lon1,az,gc_min,gc_max,gc_inc;
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
    az =  atof(argv[3]);
    gc_min = atof(argv[4])*111195.;
    gc_max = atof(argv[5])*111195.;
    gc_inc = atof(argv[6])*111195.;
  }

  if (gc_max <= gc_min){
    fprintf(stderr,"GC_MAX must be greater than GC_MIN\n");
    exit(-1);
  }

  for (i=gc_min;i<=gc_max;i+=gc_inc){
    vincenty_direct(lat1,lon1,az,i,&lat2,&lon2,&alpha21);
    fprintf(stdout,"%8.3f %8.3f %8.3f %8.3f\n",lat2,lon2,i/111195.,az,alpha21);
  }
  return(1);
}

int usage(){
  fprintf(stderr,"\n");
  fprintf(stderr,"   gc_spread creates list of stations wiht azimuth AZ from (LAT/LON)\n");
  fprintf(stderr,"   between GC_MIN and GC_MAX in GC_INC increment\n");
  fprintf(stderr,"\n");
  fprintf(stderr,"   Usage: gc_spread LAT LON AZ GC_MIN GC_MAX GC_INC\n");
  fprintf(stderr,"\n");
  fprintf(stderr,"   Output: three columns: lat, lon, gcarc, az, baz\n");
  fprintf(stderr,"\n");
  return(-1);
}






