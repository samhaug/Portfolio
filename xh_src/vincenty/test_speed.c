#include <stdio.h>
#include <string.h>
#include <stdlib.h>
/*
    raypath_point_coords computes the location of every point along a raypath
    specificed by a taup_path output file, given initial location. Also computes
    gcarc between each of these points and an earthquake location

    Samuel Haugland September 2020
*/
int usage();

int main(int argc, char *argv[]){
  float indist,inrad,intime;
  float stla=0,stlo=0,baz=200;
  double phi2,lambda2,alpha21;
  int ierr;
  FILE *ifl;

  if ((ifl = fopen(argv[1],"r")) == NULL) {
     ierr = usage();
     exit(ierr);
  }


while (!feof(ifl)){
     fscanf(ifl,"%f %f %f",&indist,&inrad,&intime);
     //find coordinates of ray point with baz
     vincenty_direct(stla,stlo,baz,indist*111195.,&phi2,&lambda2,&alpha21);
     //find gcarc from ray point to event
     //vincenty_inverse(evla,evlo,phi2,lambda2,&alpha12,&alpha21,&outgcarc);
     //only return segments of the ray that are deep
}

return(1);
}

int usage(){
  fprintf(stderr,"\n");
  fprintf(stderr,"raypath_point_coords computes the location of every\n" );
  fprintf(stderr,"point along a raypath specificed by a taup_path output file\n");
  fprintf(stderr,"given initial location.\n");
  fprintf(stderr,"\n");
  fprintf(stderr,"Usage: raypath_point_cords taup_path_file evla evlo stla stlo baz\n");
  fprintf(stderr,"   INPUT:\n");
  fprintf(stderr,"   taup_path_file: output of taup_path specifying ray\n");
  fprintf(stderr,"   evla/evlo: event latitude/longitude\n");
  fprintf(stderr,"   stla/stlo: station array centroid latitude/longitude\n");
  fprintf(stderr,"   baz: azimuth from array on which to search\n");
  fprintf(stderr,"   OUTPUT:\n");
  fprintf(stderr,"   lat, lon, depth, dist_to_eq (degrees), time\n");
  fprintf(stderr,"\n");
  return(-1);
}






