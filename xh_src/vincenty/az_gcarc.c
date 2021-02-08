#include <stdio.h>
#include <string.h>
#include <stdlib.h>
/*
     az_gcarc uses vincenty_inverse to find az, baz, and gcarc between 
     two coordinates

     Samuel Haugland June 2019
*/
int usage();

int main(int argc, char *argv[]){
  double eq_lat,eq_lon,gcarc,alpha12,alpha21;
  double st_lat,st_lon;
  double i;
  int ierr;

  if (argc != 5){
    ierr = usage();
    exit(ierr);
  }
  else{
    eq_lat =   atof(argv[1]);
    eq_lon =   atof(argv[2]);
    st_lat =   atof(argv[3]);
    st_lon =   atof(argv[4]);
  }

  vincenty_inverse(eq_lat,eq_lon,st_lat,st_lon,&alpha12,&alpha21,&gcarc);
  fprintf(stdout,"%8.3f %8.3f %8.3f\n",alpha12,alpha21,gcarc/111195.0);
  return(1);
}

int usage(){
  fprintf(stderr,"\n");
  fprintf(stderr,"   az_gcarc gives az, baz, and gcarc between EQ and station\n");
  fprintf(stderr,"\n");
  fprintf(stderr,"   Usage: az_gcarc EQ_lat EQ_lon ST_lat ST_lon\n");
  fprintf(stderr,"      Western longitudes are negative\n");
  fprintf(stderr,"\n");
  fprintf(stderr,"   Output: azimuth back-azimuth delta (all degrees)\n");
  fprintf(stderr,"\n");
  return(-1);
}






