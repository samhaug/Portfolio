#include <stdio.h>
#include <string.h>
#include <stdlib.h>
/*
    incoming_ray_coords computes the location of every point along a raypath
    specificed by a taup_path output file, given initial location. Also computes
    gcarc between each of these points and an earthquake location

    Samuel Haugland September 2020
*/
int usage();

int main(int argc, char *argv[]){
  double indist,inrad,intime;
  double evla,evlo,stla,stlo,baz;
  double phi1,phi2,lambda2,alpha21,alpha12;
  double outgcarc,gcarc;
  int ierr;
  FILE *ifl;

  if (argc != 7){
    ierr = usage();
    exit(ierr);
  }

  evla = atof(argv[2]);
  evlo = atof(argv[3]);
  stla = atof(argv[4]);
  stlo = atof(argv[5]);
  baz = atof(argv[6]);

  if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     exit(ierr);
  }

while (!feof(ifl)){
     fscanf(ifl,"%lf %lf %lf",&indist,&inrad,&intime);
     //find coordinates of ray point with baz
     vincenty_direct(stla,stlo,baz,indist*111195.,&phi2,&lambda2,&alpha21);
     //find gcarc from ray point to event
     vincenty_inverse(evla,evlo,phi2,lambda2,&alpha12,&alpha21,&outgcarc);
     //only return segments of the ray that are deeper than 800 km
     if (6371.-inrad > 800){
        fprintf(stdout,"%8.2f %8.2f %8.2f %8.2f %8.2f\n",
             outgcarc/111195.,inrad,phi2,lambda2,intime);
     }
}

return(1);
}

             //outgcarc/111195.,6371.-inrad,phi2,lambda2,intime);
int usage(){
  fprintf(stderr,"\n");
  fprintf(stderr,"incoming ray_coords computes the location of every\n" );
  fprintf(stderr,"point along a raypath specificed by a taup_path output file\n");
  fprintf(stderr,"given initial location.\n");
  fprintf(stderr,"\n");
  fprintf(stderr,"Usage: incoming_ray_coords taup_path_file evla evlo stla stlo baz\n");
  fprintf(stderr,"   INPUT:\n");
  fprintf(stderr,"   taup_path_file: output of taup_path specifying ray\n");
  fprintf(stderr,"   evla/evlo: event latitude/longitude\n");
  fprintf(stderr,"   stla/stlo: station array centroid latitude/longitude\n");
  fprintf(stderr,"   baz: azimuth from array on which to search\n");
  fprintf(stderr,"   OUTPUT:\n");
  fprintf(stderr,"   gcarc, depth lat, lon, time\n");
  fprintf(stderr,"\n");
  return(-1);
}






