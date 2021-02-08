#include <stdio.h>
#include <string.h>
#include <stdlib.h>
/*
     vincenty_inverse_file returns az, baz, and gcarc between 
     list of coordinates in ascii file

     Samuel Haugland September 2019
*/
int usage();

int main(int argc, char *argv[]){
  double gcarc,alpha12,alpha21;
  float eq_lat,eq_lon,st_lat,st_lon;
  double i;
  int ierr;
  FILE *ifl;

  if (argc != 2){
    ierr = usage();
    exit(ierr);
  }

  if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     exit(ierr);
  }

  while (!feof(ifl)){
     fscanf(ifl,"%f %f %f %f",&eq_lat,&eq_lon,&st_lat,&st_lon);
     vincenty_inverse(eq_lat,eq_lon,st_lat,st_lon,&alpha12,&alpha21,&gcarc);
     fprintf(stdout,"%8.3f %8.3f %8.3f\n",alpha12,alpha21,gcarc/111195.0);
  }
  return(1);
}

int usage(){
  fprintf(stderr,"\n");
  fprintf(stderr,"   vincenty_inverse_file gives az, baz, and gcarc between EQ and station\n");
  fprintf(stderr,"                          for whitespace delimited ascii list of EQ and station coords\n");
  fprintf(stderr,"\n");
  fprintf(stderr,"   Usage: vincenty_inverse_file IN_FILE\n");
  fprintf(stderr,"          IN_FILE is whitespace delimited floats EQ_lat EQ_lon ST_lat ST_lon\n");
  fprintf(stderr,"\n");
  fprintf(stderr,"   Output: Columar az baz gcarc (degrees)\n");
  fprintf(stderr,"\n");
  return(-1);
}






