#include <stdio.h>
#include <string.h>
#include <stdlib.h>
/*
    vincenty_direct_file computes lat/lon given inital lat/lon, az and gcarc
    values stored in input file. 

    Samuel Haugland september 2019
*/
int usage();

int main(int argc, char *argv[]){
  float phi1,lambda1,gcarc,s,az,alpha12;
  double phi2,lambda2,alpha21;
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
     fscanf(ifl,"%f %f %f %f",&phi1,&lambda1,&az,&gcarc);
     //fprintf(stdout,"%8.3f %8.3f %8.3f %8.3f\n",phi1,lambda1,az,gcarc);
     vincenty_direct(phi1,lambda1,az,gcarc*111195.,&phi2,&lambda2,&alpha21);
     fprintf(stdout,"%8.3f %8.3f %8.3f\n",phi2,lambda2,alpha21);
  }

return(1);
}

int usage(){
  fprintf(stderr,"\n");
  fprintf(stderr,"   vincenty_direct_file computes lat/lon given inital lat/lon, az and gcarc\n");
  fprintf(stderr,"   for tablular input values of ascii file\n");
  fprintf(stderr,"\n");
  fprintf(stderr,"   Usage: vincenty_direct_file IN_FILE\n");
  fprintf(stderr,"          IN_FILE must have four whitespace delimited columns: lat1 lon1 az gcarc\n");
  fprintf(stderr,"\n");
  fprintf(stderr,"   Output: lat2 lon2 baz \n");
  fprintf(stderr,"\n");
  return(-1);
}






